# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_PN="iODBC"

DESCRIPTION="ODBC Interface for Linux"
HOMEPAGE="https://www.iodbc.org/"
SRC_URI="https://github.com/openlink/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="|| ( LGPL-2 BSD )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}"

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

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/924665
	# https://github.com/openlink/iODBC/issues/100
	filter-lto

	econf \
		--disable-static \
		--enable-odbc3 \
		--enable-pthreads \
		--with-layout=gentoo \
		--with-iodbc-inidir=yes \
		$(use_enable gtk gui)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# Install lintian overrides
	insinto /usr/share/lintian/overrides
	newins debian/iodbc.lintian-overrides iodbc
	newins debian/libiodbc2.lintian-overrides libiodbc2
}
