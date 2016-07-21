# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multiprocessing toolchain-funcs

DESCRIPTION="Port of many Plan 9 programs and libraries"
HOMEPAGE="http://swtch.com/plan9port/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tgz"

LICENSE="9base BSD-4 MIT LGPL-2.1 BigelowHolmes"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X aqua truetype"
REQUIRED_USE="?? ( X aqua )"

DEPEND="X? ( x11-apps/xauth )
	truetype? ( media-libs/freetype
	            media-libs/fontconfig )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PLAN9=/usr/lib/plan9
EPLAN9="${EPREFIX}"${PLAN9}
QA_MULTILIB_PATHS="${PLAN9}/.*/.*"

src_prepare() {
	epatch "${FILESDIR}/${PN}-"{noexecstack,cflags,builderr}".patch"
	case ${CHOST} in
		*freebsd10.*)  # patch 9l to use -pthread also on FreeBSD-10
			epatch "${FILESDIR}/${PN}-freebsd-10.patch" ;;
		*apple*)
			sed -i 's/--noexecstack/-noexecstack/' src/mkhdr ||
			die "Failed to sed AFLAGS" ;;
	esac

	# don't hardcode /bin and /usr/bin in PATH
	sed -i '/PATH/s,/bin:/usr/bin:,,' INSTALL || die "sed on INSTALL failed"

	# don't hardcode /usr/{,local/}include and prefix /usr/include/*
	for f in src/cmd/fontsrv/freetyperules.sh INSTALL \
		$(find -name makefile); do
		sed -r -i -e 's,-I/usr(|/local)/include ,,g' \
		-e "s,-I/usr(|/local)/include,-I${EPREFIX}/usr\1/include,g" ${f} \
		|| die "sed on ${f} failed"
	done

	# Fix paths, done in place of ./INSTALL -c
	einfo "Fixing hard-coded /usr/local/plan9 paths"
	grep  --null -l -r '/usr/local/plan9' |
	xargs --null sed -i "s,/usr/local/plan9,${EPLAN9},g"
}

src_configure() {
	local myconf=()
	if use X; then
		myconf+=("X11=${EPREFIX}/usr" WSYSTYPE=x11)
	elif use aqua; then
		local wsystype=$(echo ${MACOSX_DEPLOYMENT_TARGET} |
		awk '{if ($1 > 10.5) print "osx-cocoa"; else print "osx"}')
		myconf+=("WSYSTYPE=${wsystype}")
	else
		myconf+=(WSYSTYPE=nowsys)
	fi

	if use truetype; then
		myconf+=(FONTSRV=fontsrv)
	else
		myconf+=(FONTSRV=)
	fi
	printf '%s\n' "${myconf[@]}" >> LOCAL.config
}

src_compile() {
	export NPROC=$(makeopts_jobs)
	export CC9=$(tc-getCC)

	# The INSTALL script builds mk then [re]builds everything using that
	einfo "Compiling Plan 9 from User Space can take a very long time"
	einfo "depending on the speed of your computer. Please be patient!"
	./INSTALL -b || die "Please report bugs to bugs.gentoo.org, NOT Plan9Port."
}

src_install() {
	dodir "${PLAN9}"

	# P9P's man does not handle compression
	docompress -x $PLAN9/man

	# do* plays with the executable bit, and we should not modify them
	cp -a * "${ED}/${PLAN9}"

	# build the environment variables and install them in env.d
	cat > "${T}/30plan9" <<-EOF
		PLAN9="${EPLAN9}"
		PATH="${EPLAN9}/bin"
		ROOTPATH="${EPLAN9}/bin"
		MANPATH="${EPLAN9}/man"
	EOF
	doenvd "${T}/30plan9"
}

pkg_postinst() {
	elog "Plan 9 from User Space has been successfully installed into"
	elog "${PLAN9}. Your PLAN9 and PATH environment variables have"
	elog "also been appropriately set, please use env-update and"
	elog "source /etc/profile to bring that into immediate effect."
	elog
	elog "Please note that ${PLAN9}/bin has been appended to the"
	elog "*end* or your PATH to prevent conflicts. To use the Plan9"
	elog "versions of common UNIX tools, use the absolute path:"
	elog "${PLAN9}/bin or the 9 command (eg: 9 troff)"
	elog
	elog "Please report any bugs to bugs.gentoo.org, NOT Plan9Port."
}
