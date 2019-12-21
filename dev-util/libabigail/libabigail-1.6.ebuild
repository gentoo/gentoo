# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit autotools python-any-r1 out-of-source

DESCRIPTION="Suite of tools for checking ABI differences between ELF objects"
HOMEPAGE="https://sourceware.org/libabigail/"
SRC_URI="https://mirrors.kernel.org/sourceware/libabigail/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/elfutils:=
	dev-libs/libxml2:2="
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		sys-apps/texinfo
	)
	test? ( ${PYTHON_DEPS} )"

src_prepare() {
	default
	# need to run our autotools, due to ltmain.sh including Redhat calls:
	# cannot read spec file '/usr/lib/rpm/redhat/redhat-hardened-ld': No such file or directory
	eautoreconf
}

my_src_configure() {
	econf \
		--disable-deb \
		--disable-fedabipkgdiff \
		--disable-rpm \
		--disable-static \
		--disable-zip-archive \
		--enable-bash-completion \
		--enable-cxx11 \
		--enable-python3 \
		$(use_enable doc apidoc) \
		$(use_enable doc manual)
}

my_src_compile() {
	default
	use doc && emake doc
}

my_src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		doman doc/manuals/man/*
		doinfo doc/manuals/texinfo/abigail.info

		dodoc -r doc/manuals/html

		docinto html/api
		dodoc -r doc/api/html/.
	fi
}

my_src_install_all() {
	einstalldocs

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
