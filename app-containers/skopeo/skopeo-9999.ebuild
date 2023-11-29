# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info

DESCRIPTION="Work with remote container images registries"
HOMEPAGE="https://github.com/containers/skopeo"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/skopeo.git"
else
	SRC_URI="https://github.com/containers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

# main
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
IUSE="btrfs device-mapper rootless"

COMMON_DEPEND="
	>=app-crypt/gpgme-1.5.5:=
	>=dev-libs/libassuan-2.4.3:=
	btrfs? ( >=sys-fs/btrfs-progs-4.0.1 )
	device-mapper? ( >=sys-fs/lvm2-2.02.145:= )
	rootless? ( sys-apps/shadow:= )
"

# TODO: Is this really needed? cause upstream doesnt mention it https://github.com/containers/skopeo/blob/main/install.md#building-from-source
# 	dev-libs/libgpg-error:=
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	app-containers/containers-common
"
BDEPEND="dev-go/go-md2man"

RESTRICT="test"
PATCHES=(
 "${FILESDIR}"/makefile-1.14.0.patch
)

pkg_setup() {
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	use device-mapper && CONFIG_CHECK+=" ~MD"
	linux-info_pkg_setup
}

src_prepare() {
	default
	local file
	for file in btrfs_installed_tag btrfs_tag libdm_tag libsubid_tag; do
		[[ -f hack/"${file}".sh ]] || die
	done

	echo -e "#!/usr/bin/env bash\n echo" > hack/btrfs_installed_tag.sh || die
	cat <<-EOF > hack/btrfs_tag.sh || die
	#!/usr/bin/env bash
	$(usex btrfs echo 'echo exclude_graphdriver_btrfs btrfs_noversion')
	EOF

	cat <<-EOF > hack/libdm_tag.sh || die
	#!/usr/bin/env bash
	$(usex device-mapper echo "echo libdm_no_deferred_remove exclude_graphdriver_devicemapper")
	EOF

	cat <<-EOF > hack/libsubid_tag.sh || die
	#!/usr/bin/env bash
	$(usex rootless "echo libsubid" echo)
	EOF
}

src_compile() {
	# export variables which 'make install' is also going to use
	export PREFIX="${EPREFIX}/usr" \
		   CONTAINERSCONFDIR="${EPREFIX}/etc/containers"
	# compile binary, docs, completions
	emake all completions
}
