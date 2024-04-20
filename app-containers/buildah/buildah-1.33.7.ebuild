# Copyright 1999-2024 Gentoo Authors
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
BDEPEND="dev-go/go-md2man"

PATCHES=(
	"${T}"/dont-call-as-directly-upstream-pr-5436.patch
)

pkg_pretend() {
	local CONFIG_CHECK=""
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	check_extra_config

	linux_config_exists || ewarn "Cannot determine configuration of your kernel."
}

src_prepare() {
	cat <<'EOF' > "${T}/dont-call-as-directly-upstream-pr-5436.patch"
--- a/Makefile
+++ b/Makefile
@@ -10,6 +10,8 @@
 BASHINSTALLDIR = $(PREFIX)/share/bash-completion/completions
 BUILDFLAGS := -tags "$(BUILDTAGS)"
 BUILDAH := buildah
+AS ?= as
+STRIP ?= strip

 GO := go
 GO_LDFLAGS := $(shell if $(GO) version|grep -q gccgo; then echo "-gccgoflags"; else echo "-ldflags"; fi)
@@ -72,11 +74,11 @@
 bin/buildah: $(SOURCES) cmd/buildah/*.go internal/mkcw/embed/entrypoint.gz
	$(GO_BUILD) $(BUILDAH_LDFLAGS) $(GO_GCFLAGS) "$(GOGCFLAGS)" -o $@ $(BUILDFLAGS) ./cmd/buildah

-ifneq ($(shell as --version | grep x86_64),)
+ifneq ($(shell $(AS) --version | grep x86_64),)
 internal/mkcw/embed/entrypoint: internal/mkcw/embed/entrypoint.s
	$(AS) -o $(patsubst %.s,%.o,$^) $^
	$(LD) -o $@ $(patsubst %.s,%.o,$^)
-	strip $@
+	$(STRIP) $@
 else
 .PHONY: internal/mkcw/embed/entrypoint
 endif
EOF

	default

	# ensure all  necessary files are there
	local file
	for file in docs/Makefile hack/libsubid_tag.sh hack/apparmor_tag.sh \
		hack/systemd_tag.sh btrfs_installed_tag.sh btrfs_tag.sh; do
		[[ -f "${file}" ]] || die
	done

	sed -i -e "s|/usr/local|/usr|g" Makefile docs/Makefile || die
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
		@@ -123 +123 @@
		-docs: install.tools ## build the docs on the host
		+docs: ## build the docs on the host
		EOF
		eapply "${T}/disable_tests.patch" || die
	}

}

src_compile() {
	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export COMMIT_NO="" GIT_COMMIT=""

	tc-export AS LD STRIP
	export GOMD2MAN="$(command -v go-md2man)"
	default
}

src_test() {
	emake test-unit
}

src_install() {
	emake DESTDIR="${ED}" install install.completions
	einstalldocs
}
