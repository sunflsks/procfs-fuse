/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void pf_destroy(void *private_data);
void *pf_init(struct fuse_conn_info *conn);
int pf_readbuf(const char *path,struct fuse_bufvec **bufp,size_t size,off_t off,struct fuse_file_info *fi);
int pf_access(const char *path,int somethign);
int pf_releasedir(const char *path,struct fuse_file_info *fi);
int pf_readdir(const char *path,void *buf,fuse_fill_dir_t filler,off_t offset,struct fuse_file_info *fi);
int pf_opendir(const char *path,struct fuse_file_info *fi);
int pf_release(const char *path,struct fuse_file_info *fi);
int pf_statfs(const char *path,struct statvfs *statvfs_out);
int pf_read(const char *path,char *dest_buf,size_t bufsz,off_t offset,struct fuse_file_info *fi);
int pf_open(const char *path,struct fuse_file_info *fi);
int pf_readlink(const char *path,char *dest_buf,size_t bufsz);
int pf_getattr(const char *path,struct stat *st_ptr);
