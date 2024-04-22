# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/otsaloma/nfoview.git"
	inherit git-r3
else
	SRC_URI="https://github.com/otsaloma/nfoview/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple viewer for NFO files, which are ASCII art in the CP437 codepage"
HOMEPAGE="https://otsaloma.io/nfoview/"

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext"
DEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	media-fonts/cascadia-code
	gui-libs/gtk:4[introspection]"

src_compile() {
	emake build \
		PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr
}
