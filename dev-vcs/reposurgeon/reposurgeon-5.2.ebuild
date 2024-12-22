# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool for editing VCS repositories and translating among different systems"
HOMEPAGE="http://www.catb.org/~esr/reposurgeon/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/esr/reposurgeon.git"
	inherit git-r3
else
	SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.xz"
# Fill the URL in with the generated Go depenency tarball.
	SRC_URI+=" http://dev.gentoo.org/~whoever/../${P}-vendor.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit go-module

LICENSE="BSD-2"
SLOT="0"
IUSE="test"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/xmlto
	app-text/asciidoc
	dev-ruby/asciidoctor"

BDEPEND="test? ( dev-vcs/subversion )"

#DOCS=( README.md CONFIGURATION.md INTRODUCTION.md LICENSE LICENSE.pycrc LICENSE.snappy )

PATCHES=(
		"${FILESDIR}"/reposurgeon-4.27-docdir.patch
		"${FILESDIR}"/reposurgeon-5.0-disable-obsolete-golint.patch
		"${FILESDIR}"/reposurgeon-5.0-use-vendored-dependencies.patch
)

RESTRICT="!test? ( test )"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		default
	fi
}

src_prepare() {
	default
	sed -e 's/GOFLAGS/MY_GOFLAGS/g' \
	    -i "${S}/Makefile" || die
}

src_compile() {
# Need -j1 otherwise it documentation is built before binaries, but the
# documentation needs output from the binaries
	emake -j1 all
}

src_install() {
	emake DESTDIR="${ED}" prefix="/usr" docdir="share/doc/${P}" install
}
