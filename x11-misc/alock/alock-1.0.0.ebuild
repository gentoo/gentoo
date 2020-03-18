# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

# we need this since there are no tagged releases yet
DESCRIPTION="locks the local X display until a password is entered"
HOMEPAGE="https://darkshed.net/projects/alock
	https://github.com/mgumz/alock"
SRC_URI="https://github.com/mgumz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc imlib pam"

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXcursor
	imlib? ( media-libs/imlib2[X] )
	pam? ( sys-libs/pam )
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/implicit_pointer_conversion_fix_amd64.patch
	"${FILESDIR}"/check-setuid.patch
	"${FILESDIR}"/tidy-printf.patch
	"${FILESDIR}"/fix-aliasing.patch
	"${FILESDIR}"/no-xf86misc.patch
)

src_configure() {
	tc-export CC

	econf \
		--prefix=/usr \
		--with-all \
		$(use_with pam) \
		$(use_with imlib imlib2)
}

src_compile() {
	# xmlto isn't required, so set to 'true' as dummy program
	# alock.1 is suitable for a manpage
	emake XMLTO=true
}

src_install() {
	dobin src/alock
	if use doc; then
		# We need to generate the manpage...
		a2x -d manpage -f manpage ./"${PN}".txt || die "a2x conversion failed."
		doman alock.1
		dodoc {CHANGELOG,README,TODO}.txt
	fi

	insinto /usr/share/alock/xcursors
	doins contrib/xcursor-*

	insinto /usr/share/alock/bitmaps
	doins bitmaps/*

	if ! use pam; then
		# Sets suid so alock can correctly work with shadow
		fperms 4755 /usr/bin/alock
	fi
}
