# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multiprocessing toolchain-funcs readme.gentoo-r1

MY_HASH="cc4571fec67407652b03d6603ada6580de2194dc"
MY_P="${PN}-${MY_HASH}"

DESCRIPTION="Port of many Plan 9 programs and libraries"
HOMEPAGE="https://9fans.github.io/plan9port/ https://github.com/9fans/plan9port"
SRC_URI="https://github.com/9fans/${PN}/archive/${MY_HASH}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="
	MIT RSA Apache-2.0 public-domain BitstreamVera BZIP2
	!freefonts? ( BigelowHolmes )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="X aqua freefonts"
REQUIRED_USE="?? ( X aqua )"

DEPEND="
	X? (
		media-libs/freetype
		media-libs/fontconfig
		x11-apps/xauth
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-noexecstack.patch"
	"${FILESDIR}/${PN}-cflags.patch"
	"${FILESDIR}/${PN}-builderr.patch"
)

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

	if use freefonts; then
		pushd font || die
		rm -r big5 fixed jis luc{,m,sans} misc naga10 pelm shinonome || die
		popd || die
		rm -r postscript/font/luxi || die
	fi

	case "${CHOST}" in
	*apple*)
		sed -i 's/--noexecstack/-noexecstack/' src/mkhdr ||
			die "Failed to sed AFLAGS" ;;
	*)
		rm -rf mac || die
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
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/858452
	# https://github.com/9fans/plan9port/issues/646
	filter-lto

	local -a myconf=(
		CC9="$(tc-getCC)"
		CC9FLAGS="'${CFLAGS} ${LDFLAGS}'"
	)

	if use X; then
		myconf+=(
			WSYSTYPE=x11
			FONTSRV=fontsrv
		)
	elif use aqua; then
		local wsystype="$(awk '{if ($1 > 10.5) print "osx-cocoa"; else print "osx"}' \
			<<< "${MACOSX_DEPLOYMENT_TARGET}")"
		myconf+=( WSYSTYPE="${wsystype}" )
	else
		myconf+=( WSYSTYPE=nowsys )
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

	rm -rf src || die

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
