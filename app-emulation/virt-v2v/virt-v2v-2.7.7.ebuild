# Copyright 1999-2025 Gentoo Authors
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

DEPEND=">=app-emulation/libguestfs-1.55.6[ocaml]
	dev-libs/json-c
	dev-libs/libpcre2
	dev-ml/libvirt-ocaml
	>sys-libs/libnbd-1.14.1-r1[ocaml]
	sys-libs/libosinfo
	>=sys-block/nbdkit-1.42.0[curl,libssh,nbd,python]
	virtual/libcrypt:="
RDEPEND="${DEPEND}
	app-arch/unzip
	app-emulation/qemu"
BDEPEND="dev-ml/findlib[ocamlopt]
	sys-devel/gettext
	dev-ml/ocaml-gettext[ocamlopt]
	dev-ml/ocaml-gettext-stub[ocamlopt]
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
	# Needs appliance built with >=libguestfs-1.55.6
	local -x SKIP_TEST_CUSTOMIZE_SH=1
	local -x SKIP_TEST_FEDORA_BTRFS_CONVERSION_SH=1
	local -x SKIP_TEST_FEDORA_CONVERSION_SH=1
	local -x SKIP_TEST_FEDORA_LUKS_ON_LVM_CONVERSION_SH=1
	local -x SKIP_TEST_FEDORA_LVM_ON_LUKS_CONVERSION_SH=1
	local -x SKIP_TEST_FEDORA_MD_CONVERSION_SH=1
	local -x SKIP_TEST_O_KUBEVIRT_FEDORA_SH=1
	# Must be called explicilty even without above variable because
	# emake check -n fails due to missing Windows headers.
	emake check
}

src_install() {
	default

	dobashcomp bash/virt-v2v
}
