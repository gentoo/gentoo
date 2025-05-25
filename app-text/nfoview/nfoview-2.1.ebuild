# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit desktop python-single-r1 virtualx xdg

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

BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	test? (
			$(python_gen_cond_dep '
				dev-python/pytest[${PYTHON_USEDEP}]
			')
	)
"
DEPEND="$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	media-fonts/cascadia-code
	gui-libs/gtk:4[introspection]"

PATCHES=( "$FILESDIR/${P}-fix-paths.patch" )

src_prepare() {
	default
	cp data/*.ui nfoview || die
}

src_compile() {
	:
}

src_test() {
	virtx epytest
}

src_install() {
	local file
	for file in po/*.po; do
		msgfmt "${file}" -o "${file%.po}.mo" && domo "${file%.po}.mo" || die
	done

	mkdir -p usr/share/{applications,metainfo} || die
	msgfmt --xml -d po --template data/io.otsaloma.nfoview.appdata.xml.in \
		-o usr/share/metainfo/io.otsaloma.nfoview.appdata.xml || die
	msgfmt --desktop -d po --template data/io.otsaloma.nfoview.desktop.in \
		-o usr/share/applications/io.otsaloma.nfoview.desktop || die

	doicon -s scalable data/io.otsaloma.nfoview.svg
	doicon -s symbolic data/io.otsaloma.nfoview-symbolic.svg

	doman data/nfoview.1

	python_moduleinto nfoview
	python_domodule nfoview/.

	python_doscript bin/nfoview

	insinto /usr
	doins -r usr/share
}
