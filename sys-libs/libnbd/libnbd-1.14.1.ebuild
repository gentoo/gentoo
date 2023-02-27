# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="NBD client library in userspace"
HOMEPAGE="https://gitlab.com/nbdkit/libnbd"
SRC_URI="https://download.libguestfs.org/libnbd/$(ver_cut 1-2)-stable/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="fuse gnutls uri-support test"

RESTRICT="!test? ( test )"

RDEPEND="
	fuse? ( sys-fs/fuse:3 )
	gnutls? ( net-libs/gnutls:= )
	uri-support? ( dev-libs/libxml2 )
"
DEPEND="
	${RDEPEND}
	test? ( sys-block/nbd[gnutls?] )
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
}

src_configure() {
	local myeconfargs=(
		$(use_enable fuse)
		$(use_with gnutls)
		$(use_with uri-support libxml2)
		--disable-ocaml
		--disable-python
		--disable-golang
	)

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
