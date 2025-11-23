# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info toolchain-funcs

DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"

# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"

SLOT="0"
IUSE="apparmor btrfs +seccomp systemd test"
RESTRICT="test"
DOCS=(
	"CHANGELOG.md"
	"troubleshooting.md"
	"docs/tutorials"
)

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/buildah.git"
else
	SRC_URI="https://github.com/containers/buildah/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

RDEPEND="
	systemd? ( sys-apps/systemd )
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp:= )
	apparmor? ( sys-libs/libapparmor:= )
	>=app-containers/containers-common-0.58.0-r1
	app-crypt/gpgme:=
	dev-db/sqlite:3=
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-apps/shadow:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-go/go-md2man"

pkg_pretend() {
	local CONFIG_CHECK=""
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	check_extra_config

	linux_config_exists || ewarn "Cannot determine configuration of your kernel."
}

src_prepare() {
	default

	# ensure all  necessary files are there
	local file
	for file in docs/Makefile hack/libsubid_tag.sh hack/apparmor_tag.sh \
		hack/systemd_tag.sh hack/sqlite_tag.sh btrfs_installed_tag.sh; do
		[[ -f "${file}" ]] || die
	done

	sed -i -e "s|/usr/local|/usr|g" Makefile docs/Makefile || die
	echo -e '#!/usr/bin/env bash\necho libsubid' > hack/libsubid_tag.sh || die

	cat <<-EOF > hack/apparmor_tag.sh || die
	#!/usr/bin/env bash
	$(usex apparmor 'echo apparmor' echo)
	EOF

	use seccomp || eapply "${FILESDIR}/${PN}-1.37.5-disable-seccomp.patch"

	cat <<-EOF > hack/systemd_tag.sh || die
	#!/usr/bin/env bash
	$(usex systemd 'echo systemd' echo)
	EOF

	cat <<-EOF > btrfs_installed_tag.sh || die
	#!/usr/bin/env bash
	$(usex btrfs echo 'echo exclude_graphdriver_btrfs')
	EOF

	# instead of statically compiling sqlite into binary dynamically link it
	# for better security and smaller binary size.
	# Refer https://github.com/containers/buildah/commit/e5b8765
	cat <<-EOF > hack/sqlite_tag.sh || die
	#!/usr/bin/env bash
	echo libsqlite3
	EOF

	use test || eapply "${FILESDIR}/${PN}-1.41.0-disable-tests.patch"
}

src_compile() {
	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export COMMIT_NO="" GIT_COMMIT=""

	tc-export AS LD STRIP
	export GOMD2MAN="$(command -v go-md2man)"
	export SELINUXOPT=
	default
}

src_test() {
	emake test-unit
}

src_install() {
	emake DESTDIR="${ED}" SELINUXOPT= install install.completions
	einstalldocs
}
