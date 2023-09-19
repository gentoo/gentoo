# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"

SLOT="0"
IUSE="apparmor btrfs +seccomp systemd doc test"
RESTRICT="test"
EXTRA_DOCS=(
	"CHANGELOG.md"
	"CONTRIBUTING.md"
	"README.md"
	"install.md"
	"troubleshooting.md"
	"docs/tutorials"
)

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/buildah.git"
else
	SRC_URI="https://github.com/containers/buildah/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	GIT_COMMIT=2326d49
	KEYWORDS="~amd64 ~arm64"
fi

DEPEND="
	systemd? ( sys-apps/systemd )
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp:= )
	apparmor? ( sys-libs/libapparmor:= )
	app-crypt/gpgme:=
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-apps/shadow:=
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	local CONFIG_CHECK=""
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	check_extra_config

	linux_config_exists || ewarn "Cannot determine configuration of your kernel."
}

src_prepare() {
	default

	sed -i -e "s|/usr/local|${EPREFIX}/usr|g" Makefile docs/Makefile || die

	[[ -f hack/libsubid_tag.sh ]] && echo -e '#!/usr/bin/env bash\necho libsubid' > hack/libsubid_tag.sh || die

	[[ -f hack/apparmor_tag.sh ]] || die
	if use apparmor; then
		echo -e '#!/usr/bin/env bash\necho apparmor' > hack/apparmor_tag.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho' > hack/apparmor_tag.sh || die
	fi

	use seccomp || {
		 cat << 'EOF' > "${T}/disable_seccomp.patch"
--- Makefile
+++ Makefile
@@ -5 +5 @@
-SECURITYTAGS ?= seccomp $(APPARMORTAG)
+SECURITYTAGS ?= $(APPARMORTAG)
EOF
		 eapply -p0 "${T}/disable_seccomp.patch" || die
	}

	[[ -f hack/systemd_tag.sh ]] || die
	if use systemd; then
		echo -e '#!/usr/bin/env bash\necho systemd' > hack/systemd_tag.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho' > hack/systemd_tag.sh || die
	fi

	[[ -f btrfs_installed_tag.sh && -f btrfs_tag.sh ]] || die
	if use btrfs; then
		echo -e '#!/usr/bin/env bash\necho btrfs_noversion' > btrfs_tag.sh || die
		echo -e '#!/usr/bin/env bash\necho' > btrfs_installed_tag.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho exclude_graphdriver_btrfs' > btrfs_installed_tag.sh || die
		echo -e '#!/usr/bin/env bash\necho' > btrfs_tag.sh || die
	fi

	use test || {
		cat << 'EOF' > "${T}/disable_tests.patch"
--- Makefile
+++ Makefile
@@ -54 +54 @@
-all: bin/buildah bin/imgtype bin/copy bin/tutorial docs
+all: bin/buildah docs
EOF
		eapply -p0 "${T}/disable_tests.patch" || die
	}

}

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		emake all
	else
		emake GIT_COMMIT=${GIT_COMMIT} all
	fi
}

src_test() {
	emake test-unit
}

src_install() {
	default
	emake DESTDIR="${D}" install.completions
	use doc && dodoc -r "${EXTRA_DOCS[@]}"
}
