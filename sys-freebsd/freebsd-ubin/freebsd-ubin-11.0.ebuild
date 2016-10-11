# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bsdmk freebsd flag-o-matic pam multilib multibuild multilib-build

DESCRIPTION="FreeBSD's base system source for /usr/bin"
SLOT="0"
IUSE="ar atm audit bluetooth ipv6 kerberos netware nis ssl usb build zfs"
LICENSE="BSD zfs? ( CDDL )"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
	SRC_URI="${SRC_URI}
		$(freebsd_upstream_patches)"
fi

EXTRACTONLY="
	usr.bin/
	contrib/
	lib/
	etc/
	bin/
	include/
"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*[usb?,bluetooth?,${MULTILIB_USEDEP}]
	ssl? ( dev-libs/openssl:0= )
	kerberos? ( virtual/krb5 )
	ar? ( >=app-arch/libarchive-3 )
	virtual/pam
	sys-libs/zlib
	>=sys-libs/ncurses-5.9:0=
	!sys-process/fuser-bsd
	!dev-util/csup
	!dev-libs/libiconv
	!sys-freebsd/freebsd-contrib"

DEPEND="${RDEPEND}
	sys-devel/flex
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )
	=sys-freebsd/freebsd-sbin-${RV}*
	=sys-freebsd/freebsd-mk-defs-${RV}*"

RDEPEND="${RDEPEND}
	>=sys-auth/pambase-20080219.1
	sys-process/cronbase"

S="${WORKDIR}/usr.bin"

PATCHES=( "${FILESDIR}/${PN}-6.0-bsdcmp.patch"
	"${FILESDIR}/${PN}-9.0-fixmakefiles.patch"
	"${FILESDIR}/${PN}-11.0-setXid.patch"
	"${FILESDIR}/${PN}-lint-stdarg.patch"
	"${FILESDIR}/${PN}-9.1-bsdar.patch"
	"${FILESDIR}/${PN}-9.1-minigzip.patch"
	"${FILESDIR}/${PN}-10.0-dtc-gcc46.patch"
	"${FILESDIR}/${PN}-10.2-talk-workaround.patch"
	"${FILESDIR}/${PN}-10.2-bsdxml.patch" )

# Here we remove some sources we don't need because they are already
# provided by portage's packages or similar. In order:
# - Archiving tools, provided by their own ebuilds
# - ncurses stuff
# - less stuff
# - bind utils
# - rsh stuff
# - binutils gprof
# - dc stuff
# and the rest are misc utils we already provide somewhere else.
REMOVE_SUBDIRS="bzip2 bzip2recover tar cpio
	gzip gprof
	lzmainfo xz xzdec
	unzip
	tput tset tabs
	less lessecho lesskey
	hesinfo host
	rsh rlogin rusers rwho ruptime
	compile_et lex vi smbutil file vacation nc ftp telnet
	c99 c89
	bc dc
	whois tftp man
	addr2line bsdcat cxxfilt cxxfilt elfcopy nm readelf sdiff size soelim strings"

pkg_setup() {
	# Add the required source files.
	use zfs && EXTRACTONLY+="cddl/ "
	use build && EXTRACTONLY+="sys/ "

	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use audit || mymakeopts="${mymakeopts} WITHOUT_AUDIT= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6= WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use nis || mymakeopts="${mymakeopts} WITHOUT_NIS= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "
	mymakeopts="${mymakeopts} WITHOUT_CLANG= WITHOUT_LZMA_SUPPORT= WITHOUT_SVN= WITHOUT_SVNLITE= WITHOUT_OPENSSH= WITHOUT_LDNS_UTILS= WITHOUT_MANDOCDB= "
}

pkg_preinst() {
	# bison installs a /usr/bin/yacc symlink ...
	# we need to remove it to avoid triggering
	# collision-protect errors
	if [[ -L ${ROOT}/usr/bin/yacc ]] ; then
		rm -f "${ROOT}"/usr/bin/yacc
	fi
}

src_prepare() {
	if [[ ! -e "${WORKDIR}/sys" ]]; then
		use build || ln -s "/usr/src/sys" "${WORKDIR}/sys"
	fi

	# Rename manpage for renamed cmp
	mv "${S}"/cmp/cmp.1 "${S}"/cmp/bsdcmp.1 || die
	# Rename manpage for renamed ar
	mv "${S}"/ar/ar.1 "${S}"/ar/freebsd-ar.1 || die
	# Fix whereis(1) manpath search.
	sed -i -e 's:"manpath -q":"manpath":' "${S}/whereis/pathnames.h"

	# Build a dynamic make
	sed -i -e '/^NO_SHARED/ s/^/#/' "${S}"/bmake/Makefile.inc || die

	# Disable it here otherwise our patch wont apply
	use ar || dummy_mk ar

	# Preparing to build xlint
	export LINT=xlint
}

setup_multilib_vars() {
	if ! multilib_is_native_abi ; then
		cd "${WORKDIR}/usr.bin/ldd" || die
		export mymakeopts="${mymakeopts} PROG=ldd32 WITHOUT_MAN="
	else
		cd "${S}" || die
	fi
	"$@"
}

src_compile() {
	# Preparing to build addr2line, elfcopy, m4
	for dir in libelftc libpe libopenbsd ; do
		cd "${WORKDIR}/lib/${dir}" || die
		freebsd_src_compile -j1
	done

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
	multibuild_foreach_variant freebsd_multilib_multibuild_wrapper setup_multilib_vars freebsd_src_compile -j1
}

src_install() {
	cd "${S}"/calendar/calendars || die
	for dir in $(find . -type d ! -name "." ) ; do
		dodir /usr/share/calendar/"$(basename ${dir})"
	done

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
	multibuild_foreach_variant freebsd_multilib_multibuild_wrapper setup_multilib_vars freebsd_src_install

	# baselayout requires these in /bin
	dodir /bin
	for bin in sed printf ; do
		mv "${D}/usr/bin/${bin}" "${D}/bin/" || die "mv ${bin} failed"
		dosym /bin/${bin} /usr/bin/${bin} || die "dosym ${bin} failed"
	done

	for pamdfile in login passwd su; do
		newpamd "${FILESDIR}/${pamdfile}.1.pamd" ${pamdfile} || die
	done

	cd "${WORKDIR}/etc" || die
	insinto /etc
	doins remote phones opieaccess fbtab || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/locate-updatedb-cron" locate.updatedb || die

	# tip requires /var/spool/lock/, bug #200700
	keepdir /var/spool/lock

	# create locate database #472468
	local f=/var/db/locate.database
	mkdir "${ED}${f%/*}" || die
	touch "${ED}${f}" || die
	fowners nobody:nobody ${f}
}

pkg_postinst() {
	# We need to ensure that login.conf.db is up-to-date.
	if [[ -e "${ROOT}"etc/login.conf ]] ; then
		einfo "Updating ${ROOT}etc/login.conf.db"
		"${ROOT}"usr/bin/cap_mkdb	-f "${ROOT}"etc/login.conf "${ROOT}"etc/login.conf
		elog "Remember to run cap_mkdb /etc/login.conf after making changes to it"
	fi
}

pkg_postrm() {
	# and if we uninstall yacc but keep bison,
	# lets restore the /usr/bin/yacc symlink
	if [[ ! -e ${ROOT}/usr/bin/yacc ]] && [[ -e ${ROOT}/usr/bin/yacc.bison ]] ; then
		ln -s yacc.bison "${ROOT}"/usr/bin/yacc
	fi
}
