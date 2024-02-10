# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"

SLOT="0"
IUSE="apparmor btrfs +seccomp systemd doc test"
RESTRICT="test"
EXTRA_DOCS=(
	"CHANGELOG.md"
	"CONTRIBUTING.md"
	"install.md"
	"troubleshooting.md"
	"docs/tutorials"
)

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/buildah.git"
else
	SRC_URI="https://github.com/containers/buildah/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64"
fi

RDEPEND="
	systemd? ( sys-apps/systemd )
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp:= )
	apparmor? ( sys-libs/libapparmor:= )
	app-containers/containers-common
	app-crypt/gpgme:=
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-apps/shadow:=
"
DEPEND="${RDEPEND}"

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
		hack/systemd_tag.sh btrfs_installed_tag.sh btrfs_tag.sh; do
		[[ -f "${file}" ]] || die
	done

	sed -i -e "s|/usr/local|${EPREFIX}/usr|g" Makefile docs/Makefile || die
	echo -e '#!/usr/bin/env bash\necho libsubid' > hack/libsubid_tag.sh || die

	cat <<-EOF > hack/apparmor_tag.sh || die
	#!/usr/bin/env bash
	$(usex apparmor 'echo apparmor' echo)
	EOF

	use seccomp || {
		cat <<-'EOF' > "${T}/disable_seccomp.patch"
		 --- a/Makefile
		 +++ b/Makefile
		 @@ -5 +5 @@
		 -SECURITYTAGS ?= seccomp $(APPARMORTAG)
		 +SECURITYTAGS ?= $(APPARMORTAG)
		EOF
		eapply "${T}/disable_seccomp.patch" || die
	}

	cat <<-EOF > hack/systemd_tag.sh || die
	#!/usr/bin/env bash
	$(usex systemd 'echo systemd' echo)
	EOF

	echo -e "#!/usr/bin/env bash\n echo" > btrfs_installed_tag.sh || die
	cat <<-EOF > btrfs_tag.sh || die
	#!/usr/bin/env bash
	$(usex btrfs echo 'echo exclude_graphdriver_btrfs btrfs_noversion')
	EOF

	use test || {
		cat <<-'EOF' > "${T}/disable_tests.patch"
		--- a/Makefile
		+++ b/Makefile
		@@ -54 +54 @@
		-all: bin/buildah bin/imgtype bin/copy bin/tutorial docs
		+all: bin/buildah docs
		EOF
		eapply "${T}/disable_tests.patch" || die
	}

}

src_compile() {
	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export COMMIT_NO="" GIT_COMMIT=""

	default
}

src_test() {
	emake test-unit
}

src_install() {
	emake DESTDIR="${D}" install install.completions
	einstalldocs
	use doc && dodoc -r "${EXTRA_DOCS[@]}"
}
