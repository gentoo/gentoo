# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit toolchain-funcs python-single-r1 linux-info

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/netblue30/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="apparmor +chroot contrib +dbusproxy +file-transfer +globalcfg +network +private-home selinux test +userns X"
REQUIRED_USE="contrib? ( ${PYTHON_REQUIRED_USE} )"
# Needs a lot of work to function within sandbox/portage. Can look at the alternative
# test targets in Makefile too, bug #769731
RESTRICT="test"

RDEPEND="
	!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )
	contrib? ( ${PYTHON_DEPS} )
	dbusproxy? ( sys-apps/xdg-dbus-proxy )
	selinux? ( sys-libs/libselinux )
"
DEPEND="
	${RDEPEND}
	sys-libs/libseccomp
	test? ( dev-tcltk/expect )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.70-envlimits.patch"
	"${FILESDIR}/${PN}-0.9.70-firecfg.config.patch"
)

pkg_setup() {
	CONFIG_CHECK="~SQUASHFS"
	local ERROR_SQUASHFS="CONFIG_SQUASHFS: required for firejail --appimage mode"
	check_extra_config

	use contrib && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Our toolchain already sets SSP by default but forcing it causes problems
	# on arches which don't support it. As for F_S, we again set it by defualt
	# in our toolchain, but forcing F_S=2 is actually a downgrade if 3 is set.
	sed -i \
		-e 's:-fstack-protector-all::' \
		-e 's:-D_FORTIFY_SOURCE=2::' \
		src/so.mk src/prog.mk || die

	find -type f -name Makefile -exec sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' {} + || die

	# Fix up hardcoded paths to templates and docs
	local files=$(grep -E -l -r '/usr/share/doc/firejail([^-]|$)' ./RELNOTES ./src/man/ ./etc/profile*/ ./test/ || die)
	for file in ${files[@]} ; do
		sed -i -r -e "s:/usr/share/doc/firejail([^-]|\$):/usr/share/doc/${PF}\1:" "${file}" || die
	done

	# remove compression of man pages
	sed -i -r -e '/rm -f \$\$man.gz; \\/d; /gzip -9n \$\$man; \\/d; s|\*\.([[:digit:]])\) install -m 0644 \$\$man\.gz|\*\.\1\) install -m 0644 \$\$man|g' Makefile || die

	if use contrib; then
		python_fix_shebang -f contrib/*.py
	fi
}

src_configure() {
	local myeconfargs=(
		--disable-fatal-warnings
		--disable-firetunnel
		--disable-lts
		--enable-suid
		$(use_enable apparmor)
		$(use_enable chroot)
		$(use_enable dbusproxy)
		$(use_enable file-transfer)
		$(use_enable globalcfg)
		$(use_enable network)
		$(use_enable private-home)
		$(use_enable selinux)
		$(use_enable userns)
		$(use_enable X x11)
	)

	econf "${myeconfargs[@]}"

	cat > 99firejail <<-EOF || die
	SANDBOX_WRITE="/run/firejail"
	EOF
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	emake test-utils test-sysutils
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
