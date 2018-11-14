# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

[[ ${PV} == *9999 ]] && SCM="git-r3"
EGIT_REPO_URI='https://github.com/jthornber/thin-provisioning-tools.git'
inherit autotools flag-o-matic $SCM

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"

if [[ ${PV} != *9999 ]]; then
	SRC_URI="https://github.com/jthornber/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="static test"

LIB_DEPEND="dev-libs/expat[static-libs(+)]
	dev-libs/libaio[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? (
		|| ( dev-lang/ruby:2.5 dev-lang/ruby:2.4 dev-lang/ruby:2.3 )
		>=dev-cpp/gtest-1.8.0
		dev-util/cucumber
		dev-util/aruba
	)
	dev-libs/boost"

PATCHES=( "${FILESDIR}"/${PN}-0.7.0-build-fixes.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	STRIP=true econf \
		--prefix="${EPREFIX}"/ \
		--bindir="${EPREFIX}"/sbin \
		--with-optimisation='' \
		$(use_enable test testing)
}

src_compile() {
	MAKEOPTS+=" V="
	default
}

src_test() {
	emake unit-test
}

src_install() {
	emake DESTDIR="${D}" DATADIR="${ED%/}/usr/share" install
	dodoc README.md TODO.org
}
