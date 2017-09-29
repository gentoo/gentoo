# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22"
# note: define maximally ONE implementation here

RUBY_OPTIONAL=no
inherit eutils multilib toolchain-funcs ruby-ng

DESCRIPTION="Viewer and editor for GDS and OASIS integrated circuit layouts"
HOMEPAGE="http://www.klayout.de/"
SRC_URI="http://www.klayout.org/downloads/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/designer:4
	dev-qt/qtgui:4[qt3support]
	sys-libs/zlib
	$(ruby_implementations_depend)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.24.9-c++11-no-throw-in-destuctor.patch
)

all_ruby_prepare() {
	# now we generate the stub build configuration file for the home-brew build system
	cp "${FILESDIR}/${PN}-0.23.10-Makefile.conf.linux-gentoo" "${S}/config/Makefile.conf.linux-gentoo" || die
}

each_ruby_configure() {
	./build.sh \
		-dry-run \
		-platform linux-gentoo \
		-bin bin \
		-ruby ${RUBY} \
		-qtbin /usr/lib64/qt4/bin \
		-qtinc /usr/include/qt4 \
		-qtlib /usr/$(get_libdir)/qt4 || die "Configuration failed"
}

each_ruby_compile() {
	cd build.linux-gentoo
	tc-export CC CXX AR LD RANLIB
	export AR="${AR} -r"
	emake all
}

each_ruby_install() {
	cd build.linux-gentoo
	emake install

	cd ..
	dobin bin/klayout

	insinto /usr/share/${PN}/testdata/gds
	doins testdata/gds/*.gds
	insinto /usr/share/${PN}/testdata/oasis
	doins testdata/oasis/*.oas testdata/oasis/*.ot

	insinto /usr/share/${PN}
	doins -r testdata/ruby
}
