# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit toolchain-funcs python-single-r1 linux-info

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/netblue30/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="apparmor +chroot contrib +dbusproxy +file-transfer +globalcfg +network +private-home test +userns X"
# Needs a lot of work to function within sandbox/portage
# bug #769731
RESTRICT="test"

RDEPEND="!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )
	contrib? ( ${PYTHON_DEPS} )
	dbusproxy? ( sys-apps/xdg-dbus-proxy )"

DEPEND="${RDEPEND}
	sys-libs/libseccomp
	test? ( dev-tcltk/expect )"

REQUIRED_USE="contrib? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${P}-envlimits.patch"
	"${FILESDIR}/${P}-firecfg.config.patch"
	)

pkg_setup() {
	CONFIG_CHECK="~SQUASHFS"
	local ERROR_SQUASHFS="CONFIG_SQUASHFS: required for firejail --appimage mode"
	check_extra_config
	use contrib && python-single-r1_pkg_setup
}

src_prepare() {
	default

	find -type f -name Makefile.in -exec sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' {} + || die

	sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die

	# fix up hardcoded paths to templates and docs
	local files=$(grep -E -l -r '/usr/share/doc/firejail([^-]|$)' ./RELNOTES ./src/man/ ./etc/profile*/ ./test/ || die)
	for file in ${files[@]} ; do
		sed -i -r -e "s:/usr/share/doc/firejail([^-]|\$):/usr/share/doc/${PF}\1:" "${file}" || die
	done

	# remove compression of man pages
	sed -i -r -e '/rm -f \$\$man.gz; \\/d; /gzip -9n \$\$man; \\/d; s|\*\.([[:digit:]])\) install -m 0644 \$\$man\.gz|\*\.\1\) install -m 0644 \$\$man|g' Makefile.in || die

	if use contrib; then
		python_fix_shebang -f contrib/*.py
	fi
}

src_configure() {
	econf \
		--disable-firetunnel \
		--enable-suid \
		$(use_enable apparmor) \
		$(use_enable chroot) \
		$(use_enable dbusproxy) \
		$(use_enable file-transfer) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable private-home) \
		$(use_enable userns) \
		$(use_enable X x11)

	cat > 99firejail <<-EOF || die
	SANDBOX_WRITE="/run/firejail"
	EOF
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	# Gentoo-specific profile customizations
	insinto /etc/${PN}
	local profile_local
	for profile_local in "${FILESDIR}"/profile_*local ; do
		newins "${profile_local}" "${profile_local/\/*profile_/}"
	done

	# Prevent sandbox violations when toolchain is firejailed
	insinto /etc/sandbox.d
	doins 99firejail

	rm "${ED}"/usr/share/doc/${PF}/COPYING || die

	if use contrib; then
		python_scriptinto /usr/$(get_libdir)/firejail
		python_doscript contrib/*.py
		insinto /usr/$(get_libdir)/firejail
		dobin contrib/*.sh
	fi
}
