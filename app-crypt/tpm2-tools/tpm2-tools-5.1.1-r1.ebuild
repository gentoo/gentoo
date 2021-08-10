# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit autotools bash-completion-r1 python-single-r1

DESCRIPTION="Tools for the TPM 2.0 TSS"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+fapi test"

RDEPEND="net-misc/curl:=
	>=app-crypt/tpm2-tss-3.0.1:=[fapi?]
	dev-libs/openssl:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm
		app-crypt/tpm2-abrmd
		app-editors/vim-core
		dev-tcltk/expect
		dev-util/cmocka
		dev-python/pyyaml
	)"
BDEPEND="virtual/pkgconfig
	sys-devel/autoconf-archive"

RESTRICT="!test? ( test )"
REQUIRED_USE=" ${PYTHON_REQUIRED_USE} "

# One of the tests fails without this patch. See
# https://github.com/tpm2-software/tpm2-tools/issues/2767
PATCHES=(
	"${FILESDIR}/${PN}-5.1.1-fix-tpm-checkquote.patch"
)

src_prepare() {
	sed -i \
	"s/m4_esyscmd_s(\[git describe --tags --always --dirty\])/${PV}/" \
	"${S}/configure.ac" || die
	"${S}/scripts/utils/man_to_bashcompletion.sh"
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable fapi) \
		$(use_enable test unit) \
		--with-bashcompdir=$(get_bashcompdir) \
		--enable-hardening
}

src_install() {
	default

	mv "${D}/$(get_bashcompdir)/tpm2_completion.bash" \
	   "${D}/$(get_bashcompdir)/tpm2" || die
	for B in "${D}"/usr/bin/tpm2_*
	do
		TPM2_UTILS="${TPM2_UTILS} $(basename ${B})"
	done
	bashcomp_alias tpm2 ${TPM2_UTILS}
}
