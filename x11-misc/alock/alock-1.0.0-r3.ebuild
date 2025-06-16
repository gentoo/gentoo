# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# We need this since there are no tagged releases yet
DESCRIPTION="locks the local X display until a password is entered"
HOMEPAGE="https://darkshed.net/projects/alock
	https://github.com/mgumz/alock"
SRC_URI="https://github.com/mgumz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="imlib pam"

DEPEND="virtual/libcrypt:=
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	imlib? ( media-libs/imlib2[X] )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"
BDEPEND="app-text/asciidoc" # needed for the manpage

PATCHES=(
	"${FILESDIR}"/implicit_pointer_conversion_fix_amd64.patch
	"${FILESDIR}"/check-setuid.patch
	"${FILESDIR}"/tidy-printf.patch
	"${FILESDIR}"/fix-aliasing.patch
	"${FILESDIR}"/no-xf86misc.patch
	"${FILESDIR}"/no-which.patch
)

src_configure() {
	tc-export CC

	econf \
		--with-all \
		$(use_with pam) \
		$(use_with imlib imlib2)
}

src_compile() {
	# xmlto isn't required, so set to 'true' as dummy program
	emake XMLTO=true
}

src_install() {
	dobin src/alock
	dodoc {CHANGELOG,README}.txt

	a2x -d manpage -f manpage ./"${PN}".txt || die "a2x conversion failed."
	doman alock.1

	insinto /usr/share/alock/xcursors
	doins contrib/xcursor-*

	insinto /usr/share/alock/bitmaps
	doins bitmaps/*

	# Set suid so alock can correctly work with shadow
	use pam || fperms 4755 /usr/bin/alock
}
