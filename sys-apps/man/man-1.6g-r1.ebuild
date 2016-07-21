# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs user

DESCRIPTION="Standard commands to read man pages"
HOMEPAGE="http://primates.ximian.com/~flucifredi/man/"
SRC_URI="http://primates.ximian.com/~flucifredi/man/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="+lzma nls selinux"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="|| ( >=sys-apps/groff-1.19.2-r1 app-doc/heirloom-doctools )
	!sys-apps/man-db
	!<app-arch/lzma-4.63
	lzma? ( app-arch/xz-utils )
	selinux? ( sec-policy/selinux-makewhatis )"

pkg_setup() {
	enewgroup man 15
	enewuser man 13 -1 /usr/share/man man
}

src_prepare() {
	epatch "${FILESDIR}"/man-1.6f-man2html-compression-2.patch
	epatch "${FILESDIR}"/man-1.6-cross-compile.patch
	epatch "${FILESDIR}"/man-1.6f-unicode.patch #146315
	epatch "${FILESDIR}"/man-1.6c-cut-duplicate-manpaths.patch
	epatch "${FILESDIR}"/man-1.5m2-apropos.patch
	epatch "${FILESDIR}"/man-1.6g-fbsd.patch #138123
	epatch "${FILESDIR}"/man-1.6e-headers.patch
	epatch "${FILESDIR}"/man-1.6f-so-search-2.patch
	epatch "${FILESDIR}"/man-1.6g-compress.patch #205147
	epatch "${FILESDIR}"/man-1.6f-parallel-build.patch #207148 #258916
	epatch "${FILESDIR}"/man-1.6g-xz.patch #302380
	epatch "${FILESDIR}"/man-1.6f-makewhatis-compression-cleanup.patch #331979
	epatch "${FILESDIR}"/man-1.6g-echo-escape.patch #523874
	# make sure `less` handles escape sequences #287183
	sed -i -e '/^DEFAULTLESSOPT=/s:"$:R":' configure
}

echoit() { echo "$@" ; "$@" ; }
src_configure() {
	strip-linguas $(eval $(grep ^LANGUAGES= configure) ; echo ${LANGUAGES//,/ })

	unset NLSPATH #175258

	tc-export CC BUILD_CC

	local mylang=
	if use nls ; then
		if [[ -z ${LINGUAS} ]] ; then
			mylang="all"
		else
			mylang="${LINGUAS// /,}"
		fi
	else
		mylang="none"
	fi
	export COMPRESS
	if use lzma ; then
		COMPRESS=/usr/bin/xz
	else
		COMPRESS=/bin/bzip2
	fi
	echoit \
	./configure \
		-confdir=/etc \
		+sgid +fhs \
		+lang ${mylang} \
		|| die "configure failed"
}

src_install() {
	unset NLSPATH #175258

	emake PREFIX="${D}" install || die "make install failed"
	dosym man /usr/bin/manpath

	dodoc LSM README* TODO

	# makewhatis only adds man-pages from the last 24hrs
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/makewhatis.cron makewhatis

	keepdir /var/cache/man
	diropts -m0775 -g man
	local mansects=$(grep ^MANSECT "${D}"/etc/man.conf | cut -f2-)
	for x in ${mansects//:/ } ; do
		keepdir /var/cache/man/cat${x}
	done
}

pkg_postinst() {
	einfo "Forcing sane permissions onto ${ROOT}var/cache/man (Bug #40322)"
	chown -R root:man "${ROOT}"/var/cache/man
	chmod -R g+w "${ROOT}"/var/cache/man
	[[ -e ${ROOT}/var/cache/man/whatis ]] \
		&& chown root:0 "${ROOT}"/var/cache/man/whatis

	echo

	local f files=$(ls "${ROOT}"/etc/cron.{daily,weekly}/makewhatis{,.cron} 2>/dev/null)
	for f in ${files} ; do
		[[ ${f} == */etc/cron.daily/makewhatis ]] && continue
		[[ $(md5sum "${f}") == "8b2016cc778ed4e2570b912c0f420266 "* ]] \
			&& rm -f "${f}"
	done
	files=$(ls "${ROOT}"etc/cron.{daily,weekly}/makewhatis{,.cron} 2>/dev/null)
	if [[ ${files/$'\n'} != ${files} ]] ; then
		ewarn "You have multiple makewhatis cron files installed."
		ewarn "You might want to delete all but one of these:"
		ewarn ${files}
	fi

	if has_version app-doc/heirloom-doctools; then
		ewarn "Please note that the /etc/man.conf file installed will not"
		ewarn "work with heirloom's nroff by default (yet)."
		ewarn ""
		ewarn "Check app-doc/heirloom-doctools elog messages for the proper"
		ewarn "configuration."
	fi
}
