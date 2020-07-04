# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library providing high performance logging, tracing, ipc, and poll"
HOMEPAGE="https://github.com/ClusterLabs/libqb"

# Avoiding release tarball due to https://github.com/ClusterLabs/libqb/issues/375
# Please re-add ChangeLog to DOCS when switching back
SRC_URI="https://github.com/ClusterLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/20"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug doc examples systemd test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	test? ( dev-libs/check )
	doc? ( app-doc/doxygen[dot] )"

DOCS=( README.markdown )

src_prepare() {
	default

	# Skip installation of text documents without value
	sed -e '/dist_doc_DATA/d' -i Makefile.am || die

	# Do not append version suffix "-yank"
	sed 's|1-yank|1|' -i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable systemd systemd-journal) \
		$(use_enable debug)
}

src_compile() {
	default
	use doc && emake doxygen
}

src_install() {
	emake install DESTDIR="${D}"

	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi

	use doc && HTML_DOCS=("docs/html/.")
	einstalldocs
}
