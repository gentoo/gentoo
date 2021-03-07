# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="event timer executor loop"
HOMEPAGE="https://github.com/any1/aml/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/any1/aml.git"
else
	SRC_URI="https://github.com/any1/aml/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="examples"

src_configure() {
	local emesonargs=(
		$(meson_use examples)
	)
	meson_src_configure
}
