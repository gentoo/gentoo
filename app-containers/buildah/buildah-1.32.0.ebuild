# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module linux-info
GIT_COMMIT=2326d49

DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
SRC_URI="https://github.com/containers/buildah/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="btrfs systemd doc test"
RESTRICT="test"

DEPEND="
	systemd? ( sys-apps/systemd )
	btrfs? ( sys-fs/btrfs-progs )
	app-crypt/gpgme:=
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-apps/shadow:=
	sys-libs/libseccomp:=
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	local CONFIG_CHECK=""
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	check_extra_config

	if ! linux_config_exists; then
		ewarn "Cannot determine configuration of your kernel."
	fi
}

src_prepare() {
	default

	[[ -f hack/systemd_tag.sh ]] || die
	if use systemd; then
		echo -e '#!/usr/bin/env bash\necho systemd' > hack/systemd_tag.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho' > hack/systemd_tag.sh || die
	fi

	[[ -f btrfs_installed_tag.sh ]] || die
	[[ -f btrfs_tag.sh ]] || die
	if use btrfs; then
		echo -e '#!/usr/bin/env bash\necho btrfs_noversion' > btrfs_tag.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho exclude_graphdriver_btrfs' > btrfs_installed_tag.sh || die
	fi

	if ! use test; then
		cat << 'EOF' > "${T}/Makefile.patch"
--- Makefile
+++ Makefile
@@ -54 +54 @@
-all: bin/buildah bin/imgtype bin/copy bin/tutorial docs
+all: bin/buildah docs
EOF
		eapply -p0 "${T}/Makefile.patch"
	fi
}

src_compile() {
	emake GIT_COMMIT=${GIT_COMMIT} all
}

src_test() {
	emake test-unit
}

src_install() {
	use doc && dodoc CHANGELOG.md CONTRIBUTING.md README.md install.md troubleshooting.md
	use doc && dodoc -r docs/tutorials
	doman docs/*.1
	dobin bin/${PN}
	dobashcomp contrib/completions/bash/buildah
}
