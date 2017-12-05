# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools toolchain-funcs

MY_P=kBuild-${PV/_/-}-src
DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="http://svn.netlabs.org/kbuild/wiki"
#SRC_URI="ftp://ftp.netlabs.org/pub/${PN}/${MY_P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~polynomial-c/${MY_P}.tar.xz
	https://dev.gentoo.org/~polynomial-c/${P}-tools_and_units_updates.patch.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-apps/texinfo
	sys-devel/flex
	sys-devel/gettext
	virtual/yacc"
RDEPEND=""

S=${WORKDIR}/${MY_P/-src}

PATCHES=(
	"${FILESDIR}/${PN}-unknown-configure-opt.patch"
	"${FILESDIR}/${PN}-glibc-2.10.patch"
	"${FILESDIR}/${PN}-0.1.5-gentoo-docdir.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20120806-qa.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20110817-kash-link-pthread.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20110817-gold.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20110817-gcc-4.7.patch"
	"${WORKDIR}/${P}-tools_and_units_updates.patch"
)

src_prepare() {
	rm -rf "${S}/kBuild/bin"

	default

	mv src/kmk/configure.{in,ac} || die

	cd "${S}/src/kmk" || die
	eautoreconf
	cd "${S}/src/sed" || die
	# AM_CONFIG_HEADER is obsolete since automake-1.13 (bug #467104)
	sed 's@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@' -i configure.ac || die
	eautoreconf

	sed -e "s@_LDFLAGS\.$(tc-arch)*.*=@& ${LDFLAGS}@g" \
		-i "${S}"/Config.kmk || die #332225
	tc-export CC RANLIB #AR does not work here
}

src_compile() {
	kBuild/env.sh --full emake -f bootstrap.gmk AUTORECONF=true AR="$(tc-getAR)" \
		|| die "bootstrap failed"
}

src_install() {
	kBuild/env.sh kmk NIX_INSTALL_DIR=/usr PATH_INS="${D}" install \
		|| die "install failed"
}
