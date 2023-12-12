# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_OPTIONAL=yes
PYTHON_COMPAT=( python3_{9..11} )
inherit perl-module ruby-ng python-single-r1 strip-linguas

DESCRIPTION="Library for reading and writing Windows Registry 'hive' binary files"
HOMEPAGE="https://libguestfs.org"
SRC_URI="https://libguestfs.org/download/${PN}/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="ocaml readline +perl python test ruby"

RDEPEND="
	dev-libs/libxml2:2
	virtual/libiconv
	virtual/libintl
	ocaml? (
		dev-lang/ocaml[ocamlopt]
		dev-ml/findlib[ocamlopt]
	 )
	perl? (
		dev-lang/perl:=
		dev-perl/IO-stringy
	)
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	ruby? ( $(ruby_implementations_depend) )
"
DEPEND="
	${RDEPEND}
	perl? (
		test? (
			dev-perl/Pod-Coverage
			dev-perl/Test-Pod-Coverage
		)
	)
"

ruby_add_bdepend "
	ruby? (
		dev-ruby/rake
		virtual/rubygems
		dev-ruby/rdoc
	)
"
ruby_add_rdepend "ruby? ( virtual/rubygems )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( || ( $(ruby_get_use_targets) ) )
"

DOCS=( README )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	default

	cp -prlP "${WORKDIR}/${P}" "${WORKDIR}"/all || die
}

src_prepare() {
	default

	use perl && perl-module_src_prepare
	use ruby && ruby-ng_src_prepare
}

src_configure() {
	use ruby && ruby-ng_src_configure

	if use perl; then
		pushd perl || die
		perl-module_src_configure
		popd || die
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

	econf "${myeconfargs[@]}"
}

each_ruby_configure() {
	local myeconfargs=(
		--without-readline
		--disable-ocaml
		--disable-perl
		--enable-nls
		--enable-ruby
		--disable-python
		--disable-rpath
	)

	export ac_cv_prog_RUBY="${RUBY}"

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	use ruby && ruby-ng_src_compile
}

each_ruby_compile() {
	# -C ruby deliberately omitted as we need the library itself built too
	emake
}

src_test() {
	emake check

	local dir
	for dir in ocaml perl python ; do
		use ${dir} && emake -C ${dir} check
	done
}

each_ruby_test() {
	emake -C ruby check
}

src_install() {
	strip-linguas -i po

	emake install DESTDIR="${ED}" "LINGUAS=""${LINGUAS}"""

	if use python; then
		python_optimize
	fi

	if use ruby; then
		ruby-ng_src_install
	fi

	if use perl; then
		perl_delete_localpod

		# Workaround Build.PL for now (see libguestfs too)
		doman "${ED}"/usr/man/man3/*
		rm -rf "${ED}"/usr/man || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

each_ruby_install() {
	emake -C ruby install DESTDIR="${ED}"
}
