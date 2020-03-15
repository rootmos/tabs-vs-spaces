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
