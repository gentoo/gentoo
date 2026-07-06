# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="line editing library for UNIX call compatible with the FSF readline"
HOMEPAGE="https://troglobit.com/projects/editline/
	https://github.com/troglobit/editline/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/troglobit/${PN}"
else
	SRC_URI="https://github.com/troglobit/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0/1.1.0"

PATCHES=( "${FILESDIR}/${PN}-1.17.1_p20240527-rename-man.patch" )

src_prepare() {
	default
	eautoreconf

	# To avoid collision with dev-libs/libedit we rename to man/libeditline.3
	mv man/editline.3 man/libeditline.3 || die

	echo "" > ./test/wrap-tmux.sh || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -type f -name "*.la" -delete || die
}
