# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit bash-completion-r1 python-single-r1

DESCRIPTION="NBD client library in userspace"
HOMEPAGE="https://gitlab.com/nbdkit/libnbd"
SRC_URI="https://download.libguestfs.org/libnbd/$(ver_cut 1-2)-stable/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples fuse gnutls go ocaml python test"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
RDEPEND="
	examples? ( dev-libs/glib dev-libs/libev )
	fuse? ( sys-fs/fuse:3 )
	gnutls? ( net-libs/gnutls:= )
	go? ( dev-lang/go )
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
	python? ( ${PYTHON_DEPS} )
	dev-libs/libxml2
"
DEPEND="
	${RDEPEND}
	test? ( sys-block/nbd[gnutls?] )
"
BDEPEND="dev-lang/perl"

DOCS=( README.md SECURITY TODO )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Fuse tests require write access to /dev/fuse which can be a security risk,
	# so they are disabledSome tests require impossible to provide features, such as fuse.
	cat <<-EOF >>tests/functions.sh.in || die
		requires_fuse ()
		{
			requires false
		}
	EOF
}

src_configure() {
	local myeconfargs=(
		$(use_enable fuse)
		$(use_enable go golang)
		$(use_enable ocaml)
		$(use_enable python)
		$(use_with gnutls)
		--with-uri-support
	)

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	use python && python_optimize
}
