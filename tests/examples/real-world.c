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
