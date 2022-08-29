function info_new = fill_Z_kmt(info)

info_new = info;
info_new.Z = generate_Z_from_POP(info.tlats,info.tlons);
info_new.kmt = locate_pop_kmt(info_new.Z,60);

end
