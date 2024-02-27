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
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE="fuse gnutls go ocaml python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# libxml2 - URI support
RDEPEND="
	dev-libs/libxml2
	fuse? ( sys-fs/fuse:3 )
	gnutls? ( net-libs/gnutls:= )
	python? ( ${PYTHON_DEPS} )
	go? ( dev-lang/go )
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
"
DEPEND="
	${RDEPEND}
	test? (
		sys-block/nbd[gnutls?]
		sys-block/nbdkit[gnutls?]
	)
"
BDEPEND="dev-lang/perl"

src_prepare() {
	default

	# Some tests require impossible to provide features, such as fuse.
	# These are marked by requires_... in the functions.sh shell
	# library.  Rather than listing these tests, let's list out the
	# impossible to support features and make them skip.
	cat <<-EOF >> tests/functions.sh.in || die
		requires_fuse ()
		{
			requires false
		}
	EOF

	# Broken under sandbox.
	cat <<-EOF > lib/test-fork-safe-execvpe.sh || die
	#!/bin/sh
	:
	EOF
}

src_configure() {
	local myeconfargs=(
		$(use_enable fuse)
		$(use_enable go golang)
		$(use_enable ocaml)
		$(use_enable python)
		$(use_with gnutls)
		--disable-rust # TODO(arsen): security bump takes priority
		--with-libxml2
	)

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	use python && python_optimize
}
