struct lines* read_lines(const char* fn)
{
    int fd = open(fn, O_RDONLY);
    if(fd == -1 && errno == ENOENT) {
#ifdef FILE_READ_LINES_ENOENT_NULL
        debug("file does not exist: %s", fn);
        return NULL;
#else
        failwith("file does not exist: %s", fn);
#endif
    }
    CHECK(fd, "open(%s)", fn);
    debug("reading file: %s", fn);

    struct line lines[FILE_MAX_LINES];
    ssize_t n_lines = 0;

    char buf[FILE_MAX_LINE_LENGTH];
    size_t l = 0;
    while(1) {
        ssize_t s = read(fd, &buf[l], 1);
        if(s == 1) {
            if(buf[l] == '\n') {
                buf[l] = 0;
                trace("read line %zu: %s", n_lines, buf);

                lines[n_lines].str = strndup(buf, l);
                CHECK_MALLOC(lines[n_lines].str);
                lines[n_lines].len = l;

                l = 0;
                n_lines += 1;
            } else {
                l += 1;
            }
        } else {
            break;
        }
    }

    int r = close(fd); CHECK(r, "close");

    struct lines* f = calloc(sizeof(struct lines), 1);
    CHECK_MALLOC(f);
    f->n_lines = n_lines;

    f->lines = calloc(sizeof(struct line), n_lines);
    CHECK_MALLOC(f->lines);
    memcpy(f->lines, lines, sizeof(struct line)*n_lines);

    return f;
}

static void render(struct server_state* st)
{
    pixel fb[st->geom.w * st->geom.h];
    struct canvas c = { .fb = fb, .w = st->geom.w, .h = st->geom.h };
    float fow = 80;
    model_draw(st->m, &c, TO_RADIANS(fow));

    char buf[1024];
    int r = snprintf(LIT(buf), "ticks: %zu", st->ticks_processed);
    text_render(&c, buf, r, 10, 10+text_line_height(), PIXEL(0xff,0xff,0xff));
    r = snprintf(LIT(buf), "fow: %.1f°", fow);
    text_render(&c, buf, r, 10, 10+2*text_line_height(), PIXEL(0xff,0xff,0xff));
    r = snprintf(LIT(buf), "git: %s", build_info_git_revid);
    text_render(&c, buf, r, 10, 10+3*text_line_height(), PIXEL(0xff,0xff,0xff));
    r = snprintf(LIT(buf), "build date: %s", build_info_date);
    text_render(&c, buf, r, 10, 10+4*text_line_height(), PIXEL(0xff,0xff,0xff));

    XImage* i = XCreateImage(st->d, st->v, 24, ZPixmap, 0, (char*)fb,
                             st->geom.w, st->geom.h, 8*sizeof(pixel),
                             sizeof(pixel)*st->geom.w);

    XPutImage(st->d, st->geom.win, st->gc, i,
              0, 0, 0, 0, st->geom.w, st->geom.h);
}
