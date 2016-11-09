# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs

# we need this since there are no tagged releases yet
COMMIT_ID="fd3ea42bda834a6b6f023291be23eb32f117f1b4"
DESCRIPTION="locks the local X display until a password is entered"
HOMEPAGE="http://darkshed.net/projects/alock
	https://github.com/mgumz/alock"
SRC_URI="https://github.com/mgumz/${PN}/archive/${COMMIT_ID}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc imlib pam"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXcursor
	imlib? ( media-libs/imlib2[X] )
	pam? ( virtual/pam )
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/implicit_pointer_conversion_fix_amd64.patch
	epatch "${FILESDIR}"/check-setuid.patch
	epatch "${FILESDIR}"/tidy-printf.patch
	epatch "${FILESDIR}"/fix-aliasing.patch
	epatch "${FILESDIR}"/no-xf86misc.patch
	eapply_user
}

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
