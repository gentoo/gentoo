# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN=GAPDoc
MY_P="${MY_PN}-${PV}"
DESCRIPTION="GAP documentation structure and tooling"
SLOT="0"
SRC_URI="https://github.com/frankluebeck/${MY_PN}/archive/relv${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-relv${PV}"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE="examples"

# PackageInfo.g defines TestFile := tst/test.tst, but that
# file doesn't exist!
RESTRICT=test

DOCS=( CHANGES README.md )

GAP_PKG_EXTRA_INSTALL=(
	bibxmlext.dtd
	gapdoc.dtd
	styles
	version
)

src_install(){
	gap-pkg_src_install

	if use examples; then
		docinto examples
		dodoc -r 3k+1
	fi

	# The "example" directory is mentioned in PackageInfo.g, so we
	# include it unconditionally, and install it in the gap package
	# directory (so that the path in PackageInfo.g is accurate).
	# Afterwards we symlink it into the usual USE=examples path.
	insinto $(gap-pkg_dir)
	doins -r example
	dosym -r $(gap-pkg_dir)/example	\
		  "/usr/share/doc/${PF}/examples/example"
}
