# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tool to convert guests from foreign hypervisors to run on KVM"
HOMEPAGE="https://libguestfs.org/"
SRC_URI="https://download.libguestfs.org/${PN}/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
if [ "${SD}" == "stable" ]; then
	KEYWORDS="~amd64"
fi
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND=">=app-emulation/libguestfs-1.56.0[ocaml]
	dev-libs/json-c
	dev-libs/libpcre2
	dev-ml/libvirt-ocaml
	sys-libs/libnbd[ocaml]
	sys-libs/libosinfo
	>=sys-block/nbdkit-1.42.0[curl,libssh,nbd,python]
	virtual/libcrypt:="
RDEPEND="${DEPEND}
	app-arch/unzip
	app-emulation/qemu"
BDEPEND="dev-ml/findlib[ocamlopt]
	dev-ml/ocaml-gettext[ocamlopt]
	dev-ml/ocaml-gettext-stub[ocamlopt]
	dev-perl/IPC-Run3
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-ml/ounit2[ocamlopt] )"

src_test() {
	# libguestfs tests won't work until the new environment is sourced
	# Automatic testers (tinderboxes) probably won't do this, so do it ourselves if needed
	if [[ -z "${LIBGUESTFS_PATH}" ]]; then
		 local -x $(<${BROOT}/etc/env.d/99libguestfs-appliance) || die
	fi

	# Can't reach libvirt from the sandbox
	local -x SKIP_TEST_O_LIBVIRT_SH=1
	# Requires libnbd "blkhash" support, which is not in portage and an automagic dependency
	# of libnbd
	local -x SKIP_TEST_O_OVIRT_UPLOAD_SH=1
	local -x SKIP_TEST_VIRTIO_WIN_ISO_SH=1
	local -x SKIP_TEST_WINDOWS_UEFI_CONVERSION_SH=1
	# Requires 3rd party Windows binaries: rhsrvany.exe or pvvxsvc.exe
	local -x SKIP_TEST_I_OVA_AS_ROOT_SH=1
	# Requires supermin
	local -x SKIP_TEST_O_OVIRT_SH=1
	# Must be called explicilty even without above variable because
	# emake check -n fails due to missing Windows headers.
	emake check
}

src_install() {
	default

	dobashcomp bash/virt-v2v
}
