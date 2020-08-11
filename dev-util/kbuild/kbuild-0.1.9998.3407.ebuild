# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_P="${P}-src"
DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="http://svn.netlabs.org/kbuild/wiki"
#SRC_URI="ftp://ftp.netlabs.org/pub/${PN}/${MY_P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~polynomial-c/${MY_P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# We cannot depend on virtual/yacc until bug #734354 has been fixed
DEPEND="
	sys-apps/texinfo
	sys-devel/flex
	sys-devel/gettext
	|| (
		dev-util/byacc
		dev-util/yacc
		<sys-devel/bison-3.7
	)
"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-0.1.9998.3407-unknown_configure_opt.patch"
	"${FILESDIR}/${PN}-0.1.5-gentoo-docdir.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20120806-qa.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20110817-kash-link-pthread.patch"
	"${FILESDIR}/${PN}-0.1.9998.3407-gold.patch"
)

pkg_setup() {
	# Package fails with distcc (bug #255371)
	export DISTCC_DISABLE=1
}

src_prepare() {
	default

	# Add a file with the svn revision this package was pulled from
	printf '%s\n' "KBUILD_SVN_REV := $(ver_cut 4)" \
		> SvnInfo.kmk || die

	cd "${S}/src/kmk" || die
	eautoreconf
	cd "${S}/src/sed" || die
	eautoreconf

	sed -e "s@_LDFLAGS\.$(tc-arch)*.*=@& ${LDFLAGS}@g" \
		-i "${S}"/Config.kmk || die #332225
	tc-export CC PKG_CONFIG RANLIB #AR does not work here
}

src_compile() {
	kBuild/env.sh --full emake -f bootstrap.gmk AUTORECONF=true AR="$(tc-getAR)" \
		|| die "bootstrap failed"
}

src_install() {
	kBuild/env.sh kmk NIX_INSTALL_DIR=/usr PATH_INS="${D}" install \
		|| die "install failed"
}
