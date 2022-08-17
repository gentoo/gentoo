# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Restricted User Shell"
HOMEPAGE="https://puszcza.gnu.org.ua/projects/rush/"
SRC_URI="https://download.gnu.org.ua/pub/release/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

BDEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	default

	# These tests see SANDBOX_* variables and fail as a result, bug #689554
	for file in tests/{eval,clr,unset,keep,set}env.at tests/legacy/env.at ; do
		echo > ${file} || die
	done
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}
