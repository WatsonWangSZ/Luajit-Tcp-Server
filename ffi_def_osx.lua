-- ffi_def_osx.lua
module(..., package.seeall)

local ffi = require "ffi"

-- Lua state - creating a new Lua state to a new thread
ffi.cdef[[
	// lua.h
	static const int LUA_GCSTOP		= 0;
	static const int LUA_GCRESTART		= 1;
	static const int LUA_GCCOLLECT		= 2;
	static const int LUA_GCCOUNT		= 3;
	static const int LUA_GCCOUNTB		= 4;
	static const int LUA_GCSTEP		= 5;
	static const int LUA_GCSETPAUSE		= 6;
	static const int LUA_GCSETSTEPMUL	= 7;
	static const int LUA_GLOBALSINDEX = -10002;

	typedef struct lua_State lua_State;

	int (lua_gc) (lua_State *L, int what, int data);
	lua_State *luaL_newstate(void);
	void luaL_openlibs(lua_State *L);
	void lua_close(lua_State *L);
	int luaL_loadstring(lua_State *L, const char *s);
	int lua_pcall(lua_State *L, int nargs, int nresults, int errfunc);
	void lua_getfield(lua_State *L, int index, const char *k);
	ptrdiff_t lua_tointeger(lua_State *L, int index);
	void lua_settop(lua_State *L, int index);
]]

-- handmade basic types
ffi.cdef[[
	// these are in sys/types.h, but is this safe universal way?
	typedef int8_t __int8_t;
	typedef int16_t __int16_t;
	typedef int32_t __int32_t;
	typedef int64_t __int64_t;

	typedef uint8_t __uint8_t;
	typedef uint16_t __uint16_t;
	typedef uint32_t __uint32_t;
	typedef uint64_t __uint64_t;

	// sys/types.h
	typedef long unsigned int __SIZE_TYPE__;
	typedef long int __PTRDIFF_TYPE__;
	typedef int __WCHAR_TYPE__;
	typedef int __WINT_TYPE__;
	typedef long int __INTMAX_TYPE__;
	typedef long unsigned int __UINTMAX_TYPE__;
]]

ffi.cdef[[
	// bad define macros, done by hand
	uint32_t htonl(uint32_t hostlong);
	uint16_t htons(uint16_t hostshort);
	uint32_t ntohl(uint32_t netlong);
	uint16_t ntohs(uint16_t netshort);

	// bad order of generated calls
	typedef __uint32_t __darwin_socklen_t;
	typedef __darwin_socklen_t socklen_t;
]]


-- everything above will stay, below will be generated --
-- ******************** --
-- generated code start --

--[[ lib_date_time.lua ]]
ffi.cdef[[
	typedef long __darwin_time_t;
	typedef __darwin_time_t time_t;
	
	double difftime(time_t, time_t);
	time_t time(time_t *);
]]

--[[ lib_http.lua ]]
--[[ lib_kqueue.lua ]]
ffi.cdef[[
	// #pragma pack(4)
	struct kevent {
	 uintptr_t ident;
	 int16_t filter;
	 uint16_t flags;
	 uint32_t fflags;
	 intptr_t data;
	 void *udata;
	};
	
	// #pragma pack()
]]

--[[ lib_poll.lua ]]
ffi.cdef[[
	static const int POLLERR = 0x0008;
	static const int POLLHUP = 0x0010;
	static const int POLLIN = 0x0001;
	static const int POLLNVAL = 0x0020;
	static const int POLLOUT = 0x0004;
	
	struct pollfd
	{
	 int fd;
	 short events;
	 short revents;
	};
	
	
	void free(void *);
	void *realloc(void *, size_t);
]]

--[[ lib_shared_memory.lua ]]
ffi.cdef[[
	static const int MAP_SHARED = 0x0001;
	static const int O_CREAT = 0x0200;
	static const int O_RDONLY = 0x0000;
	static const int O_RDWR = 0x0002;
	static const int PROT_READ = 0x01;
	static const int PROT_WRITE = 0x02;
	
	typedef __int64_t __darwin_off_t;
	typedef __darwin_off_t off_t;
	
	int close(int);
	void exit(int);
	int ftruncate(int, off_t);
	void * mmap(void *, size_t, int, int, int, off_t);
	int munmap(void *, size_t);
	int shm_open(const char *, int, ...);
	int shm_unlink(const char *);
	size_t strlen(const char *);
]]

--[[ lib_signal.lua ]]
ffi.cdef[[
	typedef __uint32_t __darwin_sigset_t;
	typedef __int32_t __darwin_pid_t;
	typedef __darwin_sigset_t sigset_t;
	typedef __darwin_pid_t pid_t;
	
	pid_t getpid(void);
	int kill(pid_t, int);
	int pthread_sigmask(int, const sigset_t *, sigset_t *);
	int sigaddset(sigset_t *, int);
	int sigemptyset(sigset_t *);
	int sigwait(const sigset_t * , int * );
]]

--[[ lib_socket.lua ]]
ffi.cdef[[
	static const int F_GETFL = 3;
	static const int F_SETFL = 4;
	static const int O_NONBLOCK = 0x0004;
	
	typedef unsigned int nfds_t;
	typedef long __darwin_ssize_t;
	typedef __uint8_t sa_family_t;
	typedef __uint32_t in_addr_t;
	struct sockaddr {
	 __uint8_t sa_len;
	 sa_family_t sa_family;
	 char sa_data[14];
	};
	
	typedef __darwin_ssize_t ssize_t;
	struct in_addr {
	 in_addr_t s_addr;
	};
	
	typedef __uint16_t in_port_t;
	struct sockaddr_in {
	 __uint8_t sin_len;
	 sa_family_t sin_family;
	 in_port_t sin_port;
	 struct in_addr sin_addr;
	 char sin_zero[8];
	};
	
	struct addrinfo {
	 int ai_flags;
	 int ai_family;
	 int ai_socktype;
	 int ai_protocol;
	 socklen_t ai_addrlen;
	 char *ai_canonname;
	 struct sockaddr *ai_addr;
	 struct addrinfo *ai_next;
	};
	
	
	int accept(int, struct sockaddr * , socklen_t * )
 ;
	int bind(int, const struct sockaddr *, socklen_t);
	int connect(int, const struct sockaddr *, socklen_t);
	int fcntl(int, int, ...);
	const char *gai_strerror(int);
	int getaddrinfo(const char * , const char * ,
       const struct addrinfo * ,
       struct addrinfo ** );
	int getnameinfo(const struct sockaddr * , socklen_t,
         char * , socklen_t, char * ,
         socklen_t, int);
	int getpeername(int, struct sockaddr * , socklen_t * )
 ;
	int getsockopt(int, int, int, void * , socklen_t * );
	const char *inet_ntop(int, const void *, char *, socklen_t);
	int listen(int, int);
	extern int poll (struct pollfd *, nfds_t, int);
	ssize_t recv(int, void *, size_t, int);
	ssize_t send(int, const void *, size_t, int);
	int setsockopt(int, int, int, const void *, socklen_t);
	int shutdown(int, int);
	int socket(int, int, int);
]]

--[[ lib_tcp.lua ]]
ffi.cdef[[
	static const int AF_INET = 2;
	static const int AF_INET6 = 30;
	static const int AI_PASSIVE = 0x00000001;
	static const int INET6_ADDRSTRLEN = 46;
	static const int INET_ADDRSTRLEN = 16;
	static const int IPPROTO_TCP = 6;
	static const int SO_RCVBUF = 0x1002;
	static const int SO_REUSEADDR = 0x0004;
	static const int SO_SNDBUF = 0x1001;
	static const int SO_USELOOPBACK = 0x0040;
	static const int SOCK_STREAM = 1;
	static const int SOL_SOCKET = 0xffff;
	static const int SOMAXCONN = 128;
	static const int TCP_NODELAY = 0x01;
	
	 struct in6_addr sin6_addr;
	struct in6_addr {
	 union {
	  __uint8_t __u6_addr8[16];
	  __uint16_t __u6_addr16[8];
	  __uint32_t __u6_addr32[4];
	 } __u6_addr;
	};
	
	struct sockaddr_storage {
	 __uint8_t ss_len;
	 sa_family_t ss_family;
	 char __ss_pad1[((sizeof(__int64_t)) - sizeof(__uint8_t) - sizeof(sa_family_t))];
	 __int64_t __ss_align;
	 char __ss_pad2[(128 - sizeof(__uint8_t) - sizeof(sa_family_t) - ((sizeof(__int64_t)) - sizeof(__uint8_t) - sizeof(sa_family_t)) - (sizeof(__int64_t)))];
	};
	
	struct sockaddr_in6 {
	 __uint8_t sin6_len;
	 sa_family_t sin6_family;
	 in_port_t sin6_port;
	 __uint32_t sin6_flowinfo;
	 struct in6_addr sin6_addr;
	 __uint32_t sin6_scope_id;
	};
	
	
	 struct in6_addr sin6_addr;
	 in_port_t sin6_port;
]]

--[[ lib_thread.lua ]]
ffi.cdef[[
	struct _opaque_pthread_attr_t { long __sig; char __opaque[56]; };
	
	typedef struct _opaque_pthread_attr_t
	   __darwin_pthread_attr_t;
	struct __darwin_pthread_handler_rec
	{
	 void (*__routine)(void *);
	 void *__arg;
	 struct __darwin_pthread_handler_rec *__next;
	};
	
	struct _opaque_pthread_t { long __sig; struct __darwin_pthread_handler_rec *__cleanup_stack; char __opaque[1168]; };
	
	typedef struct _opaque_pthread_t
	   *__darwin_pthread_t;
	typedef __darwin_pthread_attr_t pthread_attr_t;
	typedef __darwin_pthread_t pthread_t;
	
	int pthread_create(pthread_t * ,
                         const pthread_attr_t * ,
                         void *(*)(void *),
                         void * );
	void pthread_exit(void *);
	int pthread_join(pthread_t , void **);
	pthread_t pthread_self(void);
]]

--[[ lib_util.lua ]]
ffi.cdef[[
	static const int _SC_NPROCESSORS_CONF = 57;
	static const int _SC_NPROCESSORS_ONLN = 58;
	
	typedef __int32_t __darwin_suseconds_t;
	struct timespec;
	typedef __uint32_t __darwin_useconds_t;
	struct timeval
	{
	 __darwin_time_t tv_sec;
	 __darwin_suseconds_t tv_usec;
	};
	
	typedef __darwin_useconds_t useconds_t;
	
	int gettimeofday(struct timeval * , void * );
	int nanosleep(const struct timespec *, struct timespec *);
	extern int sched_yield(void);
	char *strerror(int);
	long sysconf(int);
	int usleep(useconds_t);
]]

--[[ TestAddrinfo.lua ]]
ffi.cdef[[
	static const int AI_CANONNAME = 0x00000002;
	static const int NI_MAXHOST = 1025;
	static const int NI_MAXSERV = 32;
	static const int NI_NAMEREQD = 0x00000004;
	static const int NI_NUMERICHOST = 0x00000002;
	static const int NI_NUMERICSERV = 0x00000008;
]]

--[[ TestAll.lua ]]
--[[ TestKqueue.lua ]]
ffi.cdef[[
	static const int EV_ADD = 0x0001;
	static const int EV_ENABLE = 0x0004;
	static const int EV_ONESHOT = 0x0010;
	static const int EVFILT_VNODE = (-4);
	static const int NOTE_ATTRIB = 0x00000008;
	static const int NOTE_DELETE = 0x00000001;
	static const int NOTE_EXTEND = 0x00000004;
	static const int NOTE_WRITE = 0x00000002;
	
	int kevent(int kq, const struct kevent *changelist, int nchanges,
      struct kevent *eventlist, int nevents,
      const struct timespec *timeout);
	int kqueue(void);
	int open(const char *, int, ...);
]]

--[[ TestLinux.lua ]]
ffi.cdef[[
	static const int O_EXCL = 0x0800;
]]

--[[ TestSharedMemory.lua ]]
--[[ TestSignal.lua ]]
--[[ TestSignal_bad.lua ]]
ffi.cdef[[
	int pause(void);
	void (*signal(int, void (*)(int)))(int);
]]

--[[ TestSocket.lua ]]
--[[ TestThread.lua ]]

--[[
not found calls = {
   [1] = "--- lib_date_time.lua ---";
   [2] = "date";
   [3] = "--- lib_http.lua ---";
   [4] = "--- lib_kqueue.lua ---";
   [5] = "--- lib_poll.lua ---";
   [6] = "--- lib_shared_memory.lua ---";
   [7] = "CloseHandle";
   [8] = "CreateFileMappingA";
   [9] = "GetLastError";
   [10] = "MapViewOfFile";
   [11] = "OpenFileMappingA";
   [12] = "UnmapViewOfFile";
   [13] = "--- lib_signal.lua ---";
   [14] = "--- lib_socket.lua ---";
   [15] = "closesocket";
   [16] = "ioctlsocket";
   [17] = "WSAAddressToStringA";
   [18] = "WSACleanup";
   [19] = "WSAGetLastError";
   [20] = "WSAPoll";
   [21] = "WSAStartup";
   [22] = "--- lib_tcp.lua ---";
   [23] = "--- lib_thread.lua ---";
   [24] = "CreateThread";
   [25] = "GetCurrentThreadId";
   [26] = "INFINITE";
   [27] = "WaitForSingleObject";
   [28] = "--- lib_util.lua ---";
   [29] = "ENABLE_ECHO_INPUT";
   [30] = "ENABLE_LINE_INPUT";
   [31] = "FORMAT_MESSAGE_FROM_SYSTEM";
   [32] = "FORMAT_MESSAGE_IGNORE_INSERTS";
   [33] = "GetConsoleMode";
   [34] = "GetStdHandle";
   [35] = "GetSystemInfo";
   [36] = "QueryPerformanceCounter";
   [37] = "QueryPerformanceFrequency";
   [38] = "ReadConsoleA";
   [39] = "SetConsoleMode";
   [40] = "Sleep";
   [41] = "STD_INPUT_HANDLE";
   [42] = "SwitchToThread";
   [43] = "--- TestAddrinfo.lua ---";
   [44] = "--- TestAll.lua ---";
   [45] = "--- TestKqueue.lua ---";
   [46] = "INFINITE";
   [47] = "--- TestLinux.lua ---";
   [48] = "--- TestSharedMemory.lua ---";
   [49] = "--- TestSignal.lua ---";
   [50] = "--- TestSignal_bad.lua ---";
   [51] = "--- TestSocket.lua ---";
   [52] = "SD_SEND";
   [53] = "--- TestThread.lua ---";
};
]]
