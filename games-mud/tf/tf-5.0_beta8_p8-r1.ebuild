# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_p*/}"
MY_PV="$(ver_rs 1 '' "${MY_PV}")"
# 5.0_beta8_p8 -> 5.0beta8-8
MY_DEB_PV="$(ver_cut 1-2)$(ver_cut 3-4)-$(ver_cut 6)"

DESCRIPTION="A small, flexible, screen-oriented MUD client (aka TinyFugue)"
HOMEPAGE="http://tinyfugue.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/tinyfugue/tf-${MY_PV}.tar.gz
	mirror://debian/pool/main/t/tf5/tf5_${MY_DEB_PV}.debian.tar.xz
	http://homepage.mac.com/mikeride/abelinc/scripts/allrootpatch.txt -> tf-allrootpatch.txt
	http://homepage.mac.com/mikeride/abelinc/scripts/allsrcpatch.txt -> tf-allsrcpatch.txt
	doc? ( mirror://sourceforge/tinyfugue/tf-${MY_PV}-help.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+atcp doc +gmcp ipv6 +option102 ssl"

RDEPEND="
	dev-libs/libpcre
	sys-libs/ncurses:=
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/tf-${MY_PV}"

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${DISTDIR}"/tf-allrootpatch.txt
	"${DISTDIR}"/tf-allsrcpatch.txt
	"${FILESDIR}"/tf-50_beta8-pcre.patch
	"${FILESDIR}"/tf-5.0_beta8_p8-Fix-implicit-function-declarations.patch
)

src_configure() {
	STRIP=: econf \
		$(use_enable atcp) \
		$(use_enable gmcp) \
		$(use_enable option102) \
		$(use_enable ssl) \
		$(use_enable ipv6 inet6) \
		--enable-manpage \
		--enable-termcap=tinfo
}

src_install() {
	dobin src/tf
	newman src/tf.1.nroffman tf.1

	use doc && HTML_DOCS=( ../${MY_P}-help/{*.html,commands,topics} )
	einstalldocs

	insinto /usr/share/${PN}-lib
	# the application looks for this file here if /changes is called.
	# see comments on bug #23274
	doins CHANGES
	insopts -m0755
	doins -r tf-lib/.
}

pkg_postinst() {
	if use ipv6; then
		ewarn
		ewarn "You have merged TinyFugue with IPv6-support."
		ewarn "Support for IPv6 is still being experimental."
		ewarn "If you experience problems with connecting to hosts,"
		ewarn "try re-merging this package with USE="-ipv6""
		ewarn
	fi
}
