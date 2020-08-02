# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_OPTIONAL=yes

PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils perl-module ruby-ng python-single-r1

DESCRIPTION="Library for reading and writing Windows Registry 'hive' binary files"
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocaml readline +perl python test static-libs ruby"

RDEPEND="
	virtual/libiconv
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml[ocamlopt]
			 dev-ml/findlib[ocamlopt]
			 )
	readline? ( sys-libs/readline:0 )
	perl? (
		dev-lang/perl:=
		dev-perl/IO-stringy
	)
	ruby? ( $(ruby_implementations_depend) )
	python? ( ${PYTHON_DEPS} )
	"

DEPEND="${RDEPEND}
	perl? (
		test? ( dev-perl/Pod-Coverage
			dev-perl/Test-Pod-Coverage )
		  )
	"

ruby_add_bdepend "ruby? ( dev-ruby/rake
			virtual/rubygems
			dev-ruby/rdoc )"
ruby_add_rdepend "ruby? ( virtual/rubygems )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
			ruby? ( || ( $(ruby_get_use_targets) ) )"

DOCS=( README )

S="${WORKDIR}/${P}"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_unpack() {
	default
	cp -prlP "${WORKDIR}/${P}" "${WORKDIR}"/all
}

src_configure() {
	ruby-ng_src_configure

	if use perl; then
		pushd perl
		perl-module_src_configure
		popd
	fi

	local myeconfargs=(
		$(use_with readline)
		$(use_enable ocaml)
		$(use_enable perl)
		--enable-nls
		--disable-ruby
		$(use_enable python)
		--disable-rpath
		)

	econf ${myeconfargs[@]}
}

src_compile() {
	default
	ruby-ng_src_compile
}

src_install() {
	strip-linguas -i po

	emake install DESTDIR="${ED}" "LINGUAS=""${LINGUAS}"""
	if use python; then
		python_optimize
	fi

	ruby-ng_src_install

	if use perl; then
		perl_delete_localpod
	fi
}
