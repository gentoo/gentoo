# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_PN="iODBC"

DESCRIPTION="ODBC Interface for Linux"
HOMEPAGE="http://www.iodbc.org/"
SRC_URI="https://github.com/openlink/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="|| ( LGPL-2 BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

MULTILIB_CHOST_TOOLS=( /usr/bin/iodbc-config )

PATCHES=(
	"${FILESDIR}"/${PN}-3.52.12-multilib.patch
	"${FILESDIR}"/${PN}-3.52.7-debian_bug501100.patch
	"${FILESDIR}"/${PN}-3.52.7-unicode_includes.patch
	"${FILESDIR}"/fix-runpaths-r1.patch
)

src_prepare() {
	default

	sed -i.orig \
		-e '/^cd "$PREFIX"/,/^esac/d' \
		iodbc/install_libodbc.sh || die "sed failed"

	# Without this, automake dies. It's what upstream's autogen.sh does.
	touch ChangeLog || die "failed to create empty ChangeLog"

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--enable-odbc3 \
		--enable-pthreads \
		--with-layout=gentoo \
		--with-iodbc-inidir=yes \
		$(use_enable gtk gui)
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -delete || die

	# Install lintian overrides
	insinto /usr/share/lintian/overrides
	newins debian/iodbc.lintian-overrides iodbc
	newins debian/libiodbc2.lintian-overrides libiodbc2
}
