# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs readme.gentoo-r1

MY_HASH="a6ad39aaaa36b8aadc5c35bfc803afbde32918c0"
MY_P="${PN}-${MY_HASH}"

DESCRIPTION="Port of many Plan 9 programs and libraries"
HOMEPAGE="https://9fans.github.io/plan9port/
	https://github.com/9fans/plan9port"
SRC_URI="https://github.com/9fans/${PN}/archive/${MY_HASH}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="9base BSD-4 MIT LGPL-2.1 BigelowHolmes"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X aqua truetype"
REQUIRED_USE="?? ( X aqua )"

DEPEND="
	X? ( x11-apps/xauth )
	truetype? (
		media-libs/freetype
		media-libs/fontconfig
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-noexecstack.patch"
	"${FILESDIR}/${PN}-cflags.patch"
	"${FILESDIR}/${PN}-builderr.patch"
)

S="${WORKDIR}/${MY_P}"

PLAN9="/opt/plan9"
EPLAN9="${EPREFIX}${PLAN9}"
QA_MULTILIB_PATHS="${PLAN9}/.*/.*"

DOC_CONTENTS="Plan 9 from User Space has been successfully installed into
${PLAN9}. Your PLAN9 and PATH environment variables have
also been appropriately set, please use env-update and
source /etc/profile to bring that into immediate effect.

Please note that ${PLAN9}/bin has been appended to the
*end* or your PATH to prevent conflicts. To use the Plan9
versions of common UNIX tools, use the absolute path:
${PLAN9}/bin or the 9 command (eg: 9 troff)

Please report any bugs to bugs.gentoo.org, NOT Plan9Port."
DISABLE_AUTOFORMATTING="yes"

src_prepare() {
	default

	case "${CHOST}" in
		*apple*)
			sed -i 's/--noexecstack/-noexecstack/' src/mkhdr ||
				die "Failed to sed AFLAGS" ;;
	esac

	# don't hardcode /bin and /usr/bin in PATH
	sed -i '/PATH/s,/bin:/usr/bin:,,' INSTALL || die "sed on INSTALL failed"

	# don't hardcode /usr/{,local/}include and prefix /usr/include/*
	sed -Ei -e 's,-I/usr(|/local)/include ,,g' \
		-e "s,-I/usr(|/local)/include,-I${EPREFIX}/usr\1/include,g" \
		src/cmd/fontsrv/freetyperules.sh INSTALL $(find -name makefile) ||
		die "sed failed"

	# Fix paths, done in place of ./INSTALL -c
	einfo "Fixing hard-coded /usr/local/plan9 paths"
	sed -i "s,/usr/local/plan9,${EPLAN9},g" $(grep -lr /usr/local/plan9) ||
		die "sed failed"
}

src_configure() {
	local -a myconf=(
		CC9="$(tc-getCC)"
		CC9FLAGS="'${CFLAGS} ${LDFLAGS}'"
	)

	if use X; then
		myconf+=( WSYSTYPE=x11 )
	elif use aqua; then
		local wsystype="$(awk '{if ($1 > 10.5) print "osx-cocoa"; else print "osx"}' \
			<<< "${MACOSX_DEPLOYMENT_TARGET}")"
		myconf+=( WSYSTYPE="${wsystype}" )
	else
		myconf+=( WSYSTYPE=nowsys )
	fi

	if use truetype; then
		myconf+=( FONTSRV=fontsrv )
	else
		myconf+=( FONTSRV= )
	fi

	printf '%s\n' "${myconf[@]}" >> LOCAL.config ||
		die "cannot create configuration"
}

src_compile() {
	# The INSTALL script builds mk then [re]builds everything using that
	einfo "Compiling Plan 9 from User Space can take a very long time"
	einfo "depending on the speed of your computer. Please be patient!"
	NPROC="$(makeopts_jobs)" ./INSTALL -b ||
		die "Please report bugs to bugs.gentoo.org, NOT Plan9Port."
}

src_install() {
	readme.gentoo_create_doc

	# do* plays with the executable bit, and we should not modify them
	dodir "${PLAN9}"
	cp -a * "${ED}${PLAN9}" || die "cp failed"

	# build the environment variables and install them in env.d
	newenvd - 60plan9 <<-EOF
		PLAN9="${EPLAN9}"
		PATH="${EPLAN9}/bin"
		ROOTPATH="${EPLAN9}/bin"
		MANPATH="${EPLAN9}/man"
	EOF
}

pkg_postinst() {
	readme.gentoo_print_elog
}
