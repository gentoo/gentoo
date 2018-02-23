# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
else
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="image loader plugins for Imlib 2"
HOMEPAGE="https://www.enlightenment.org/pages/imlib2.html"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="eet xcf"

RDEPEND=">=media-libs/imlib2-${PV}
	eet? ( dev-libs/efl )"

src_configure() {
	E_ECONF=(
		$(use_enable eet)
		$(use_enable xcf)
	)

	enlightenment_src_configure
}
