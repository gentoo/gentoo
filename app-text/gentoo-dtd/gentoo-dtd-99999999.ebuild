# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/data/dtd.git"
else
	# git archive --prefix=${P}/ HEAD | xz >${P}.tar.xz
	SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Document Type Definition for Gentoo-related XML files"
HOMEPAGE="https://gitweb.gentoo.org/data/dtd.git/"

# Presumably these simple DTDs are not copyrightable,
# but repositories.dtd says GPL v2 or later.
LICENSE="public-domain GPL-2+"
SLOT="0"

RDEPEND="dev-libs/libxml2"
IDEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/xml/gentoo/dtd
	doins *.dtd
}

pkg_postinst() {
	ebegin "Installing catalog entry"
	xmlcatalog --noout \
		--add rewriteSystem "http://www.gentoo.org/dtd/" \
			"file://${EPREFIX}/usr/share/xml/gentoo/dtd/" \
		--add rewriteSystem "https://www.gentoo.org/dtd/" \
			"file://${EPREFIX}/usr/share/xml/gentoo/dtd/" \
		"${EROOT}"/etc/xml/catalog
	eend $?
}

pkg_postrm() {
	ebegin "Cleaning catalog"
	xmlcatalog --noout \
		--del "http://www.gentoo.org/dtd/" \
		--del "https://www.gentoo.org/dtd/" \
		"${EROOT}"/etc/xml/catalog
	eend $?
}
