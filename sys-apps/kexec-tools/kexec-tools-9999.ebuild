# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool linux-info systemd

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git"
else
	SRC_URI="https://www.kernel.org/pub/linux/utils/kernel/kexec/${P/_/-}.tar.xz"
	[[ "${PV}" == *_rc* ]] || \
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="https://kernel.org/pub/linux/utils/kernel/kexec/"

LICENSE="GPL-2"
SLOT="0"
IUSE="booke lzma xen zlib"

REQUIRED_USE="lzma? ( zlib )"

DEPEND="
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_/-}"

CONFIG_CHECK="~KEXEC"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-disable-kexec-test.patch
	"${FILESDIR}"/${PN}-2.0.4-out-of-source.patch
)

pkg_setup() {
	# GNU Make's $(COMPILE.S) passes ASFLAGS to $(CCAS), CCAS=$(CC)
	export ASFLAGS="${CCASFLAGS}"
}

src_prepare() {
	default

	# Append PURGATORY_EXTRA_CFLAGS flags set by configure, instead of overriding them completely.
	sed -e "/^PURGATORY_EXTRA_CFLAGS =/s/=/+=/" -i Makefile.in || die

	if [[ "${PV}" == 9999 ]] ; then
		eautoreconf
	else
		elibtoolize
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with booke)
		$(use_with lzma)
		$(use_with xen)
		$(use_with zlib)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Respect CFLAGS for purgatory.
	# purgatory/Makefile uses PURGATORY_EXTRA_CFLAGS variable.
	# -mfunction-return=thunk and -mindirect-branch=thunk conflict with
	# -mcmodel=large which is added by build system.
	# Replace them with -mfunction-return=thunk-inline and -mindirect-branch=thunk-inline.
	local flag flags=()
	for flag in ${CFLAGS}; do
		[[ ${flag} == -mfunction-return=thunk ]] && flag="-mfunction-return=thunk-inline"
		[[ ${flag} == -mindirect-branch=thunk ]] && flag="-mindirect-branch=thunk-inline"
		flags+=("${flag}")
	done
	local -x PURGATORY_EXTRA_CFLAGS="${flags[*]}"

	default
}

src_install() {
	default

	dodoc "${FILESDIR}"/README.Gentoo

	newinitd "${FILESDIR}"/kexec.init-2.0.13-r1 kexec
	newconfd "${FILESDIR}"/kexec.conf-2.0.4 kexec

	insinto /etc
	doins "${FILESDIR}"/kexec.conf

	insinto /etc/kernel/postinst.d
	doins "${FILESDIR}"/90_kexec

	systemd_dounit "${FILESDIR}"/kexec.service
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "For systemd support the new config file is"
		elog "   /etc/kexec.conf"
		elog "Please adopt it to your needs as there is no autoconfig anymore"
	fi
}
