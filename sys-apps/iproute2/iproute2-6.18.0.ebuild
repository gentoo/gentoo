# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a edo toolchain-funcs flag-o-matic

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git"
	inherit git-r3
else
	SRC_URI="https://www.kernel.org/pub/linux/utils/net/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="kernel routing and traffic control utilities"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iproute2"

LICENSE="GPL-2"
SLOT="0"
IUSE="atm berkdb bpf caps elf +iptables minimal nfs selinux"
# Needs root
RESTRICT="test"

# We could make libmnl optional, but it's tiny, so eh
RDEPEND="
	!minimal? ( net-libs/libmnl:= )
	atm? ( net-dialup/linux-atm )
	berkdb? ( sys-libs/db:= )
	bpf? ( >=dev-libs/libbpf-0.6:= )
	caps? ( sys-libs/libcap )
	elf? ( virtual/libelf:= )
	iptables? ( >=net-firewall/iptables-1.4.20:= )
	nfs? ( net-libs/libtirpc:= )
	selinux? ( sys-libs/libselinux )
"
# We require newer linux-headers for ipset support (bug #549948) and some defines (bug #553876)
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-3.16
"
BDEPEND="
	app-arch/xz-utils
	>=sys-devel/bison-2.4
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.10.0-musl-2.patch # bug #926341
	"${FILESDIR}"/${PN}-6.9.0-mtu.patch # bug #291907
	"${FILESDIR}"/${PN}-6.8.0-configure-nomagic-nolibbsd.patch # bug #643722 & #911727
	"${FILESDIR}"/${PN}-6.8.0-disable-libbsd-fallback.patch # bug #911727
	"${FILESDIR}"/${PN}-6.18.0-netshaper.patch # bug #967691
	"${FILESDIR}"/${PN}-6.18.0-musl.patch # bug #967701
)

src_prepare() {
	default

	# Fix version if necessary
	local versionfile="include/version.h"
	if [[ ${PV} != 9999 ]] && ! grep -Fq "${PV}" ${versionfile} ; then
		einfo "Fixing version string"
		sed -i "s@\"[[:digit:]\.]\+\"@\"${PV}\"@" \
			${versionfile} || die
	fi

	# echo -n is not POSIX compliant
	sed -i 's@echo -n@printf@' configure || die

	sed -i \
		-e '/^CC :\?=/d' \
		-e "/^LIBDIR/s:=.*:=/$(get_libdir):" \
		-e "s|-O2|${CFLAGS} ${CPPFLAGS}|" \
		-e "/^HOSTCC/s:=.*:= $(tc-getBUILD_CC):" \
		-e "/^DBM_INCLUDE/s:=.*:=${T}:" \
		Makefile || die

	# Build against system headers
	rm -r include/netinet || die #include/linux include/ip{,6}tables{,_common}.h include/libiptc
	sed -i 's:TCPI_OPT_ECN_SEEN:16:' misc/ss.c || die

	if use minimal ; then
		sed -i -e '/^SUBDIRS=/s:=.*:=lib tc ip:' Makefile || die
	fi
}

src_configure() {
	tc-export AR CC PKG_CONFIG
	lto-guarantee-fat

	tc-export_build_env
	export CBUILD_CFLAGS=${BUILD_CFLAGS}

	# This sure is ugly. Should probably move into toolchain-funcs at some point.
	local setns
	pushd "${T}" >/dev/null || die
	printf '#include <sched.h>\nint main(){return setns(0, 0);}\n' > test.c || die
	if ${CC} ${CFLAGS} ${CPPFLAGS} -D_GNU_SOURCE ${LDFLAGS} test.c >&/dev/null ; then
		setns=y
	else
		setns=n
	fi

	echo 'int main(){return 0;}' > test.c || die
	if ! ${CC} ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} test.c -lresolv >&/dev/null ; then
		sed -i '/^LDLIBS/s:-lresolv::' "${S}"/Makefile || die
	fi
	popd >/dev/null || die

	# build system does not pass CFLAGS to LDFLAGS, as is recommended by GCC upstream
	# https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-flto
	# https://bugs.gentoo.org/929233
	append-ldflags ${CFLAGS}

	# run "configure" script first which will create "config.mk"...
	# Using econf breaks since 5.14.0 (a9c3d70d902a0473ee5c13336317006a52ce8242)
	eval "local -a EXTRA_ECONF=(${EXTRA_ECONF})"
	edo ./configure --libbpf_force $(usex bpf on off) "${EXTRA_ECONF[@]}"

	# Remove the definitions made by configure and allow them to be overridden
	# by USE flags below.
	# We have to do the cheesy only-sed-if-disabled because otherwise
	# the *_FLAGS etc stuff found by configure will be used but result
	# in a broken build.
	if ! use berkdb ; then
		sed -i -e '/HAVE_BERKELEY_DB/d' config.mk || die
	fi

	if ! use caps ; then
		sed -i -e '/HAVE_CAP/d' config.mk || die
	fi

	if use minimal ; then
		sed -i -e '/HAVE_MNL/d' config.mk || die
	fi

	if ! use elf ; then
		sed -i -e '/HAVE_ELF/d' config.mk || die
	fi

	if ! use nfs ; then
		sed -i -e '/HAVE_RPC/d' config.mk || die
	fi

	if ! use selinux ; then
		sed -i -e '/HAVE_SELINUX/d' config.mk || die
	fi

	# ...Now switch on/off requested features via USE flags
	# this is only useful if the test did not set other things, per bug #643722
	# Keep in sync with ifs above, or refactor to be unified.
	cat <<-EOF >> config.mk
	TC_CONFIG_ATM := $(usex atm y n)
	TC_CONFIG_XT  := $(usex iptables y n)
	TC_CONFIG_NO_XT := $(usex iptables n y)
	# We've locked in recent enough kernel headers, bug #549948
	TC_CONFIG_IPSET := y
	HAVE_BERKELEY_DB := $(usex berkdb y n)
	HAVE_CAP      := $(usex caps y n)
	HAVE_MNL      := $(usex minimal n y)
	HAVE_ELF      := $(usex elf y n)
	HAVE_RPC      := $(usex nfs y n)
	HAVE_SELINUX  := $(usex selinux y n)
	IP_CONFIG_SETNS := ${setns}
	# Use correct iptables dir, bug #144265, bug #293709
	IPT_LIB_DIR   := $(use iptables && ${PKG_CONFIG} xtables --variable=xtlibdir)
	EOF
}

src_compile() {
	emake V=1 NETNS_RUN_DIR=/run/netns
}

src_test() {
	emake check
}

src_install() {
	if use minimal ; then
		into /
		dosbin tc/tc
		dobin ip/ip
		return 0
	fi

	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}"/$(get_libdir) \
		SBINDIR="${EPREFIX}"/sbin \
		CONFDIR="${EPREFIX}"/etc/iproute2 \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		MANDIR="${EPREFIX}"/usr/share/man \
		ARPDDIR="${EPREFIX}"/var/lib/arpd \
		install

	dodir /bin
	mv "${ED}"/{s,}bin/ip || die # bug #330115
	mv "${ED}"/{s,}bin/ss || die # bug #547264

	dolib.a lib/libnetlink.a
	insinto /usr/include
	doins include/libnetlink.h

	# Collides with net-analyzer/ifstat
	# https://bugs.gentoo.org/868321
	mv "${ED}"/sbin/ifstat{,-iproute2} || die

	if use berkdb ; then
		keepdir /var/lib/arpd
		# bug #47482, arpd doesn't need to be in /sbin
		dodir /usr/bin
		mv "${ED}"/sbin/arpd "${ED}"/usr/bin/ || die
	elif [[ -d "${ED}"/var/lib/arpd ]]; then
		rmdir --ignore-fail-on-non-empty -p "${ED}"/var/lib/arpd || die
	fi
	strip-lto-bytecode
}
