# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion optfeature systemd toolchain-funcs

DESCRIPTION="Free Client for OneDrive on Linux"
HOMEPAGE="https://abraunegg.github.io/"
SRC_URI="https://codeload.github.com/abraunegg/onedrive/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify"
# Barely any tests that require manually building.
# Manual testing seems to be the best approach
RESTRICT="test"

RDEPEND="
	>=dev-db/sqlite-3.7.15:3
	net-misc/curl
	sys-apps/dbus
	libnotify? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	|| (
	   sys-devel/gcc:15[d]
	   sys-devel/gcc:16[d]
	)
"
MIN_GCC_SLOT=15
MAX_GCC_SLOT=16

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && _setup_gdc
}

src_configure() {
	# GDCFLAGS are meant to be specified in make.conf. Avoid the DFLAGS
	# name to support ::dlang which needs separate variables for each
	# compiler's flags
	DCFLAGS="${GDCFLAGS}"
	# libphobos does not provide any backwards compatibility guarantees.
	# Until the gcc dependency is properly slotted and a USE-expand flag
	# is added, use static linking.
	DCFLAGS+=" -static-libphobos ${LDFLAGS}"
	export DCFLAGS

	myeconfargs=(
		$(use_enable libnotify notifications)
		--with-bash-completion-dir="$(get_bashcompdir)"
		--with-zsh-completion-dir="$(get_zshcompdir)"
		--with-fish-completion-dir="$(get_fishcompdir)"
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		--enable-completions
		--disable-version-check
		# Adds -g and -debug. There are only a few instructions guarded by debug
		--disable-debug
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Avoid overwriting user flags
	emake DCFLAGS="${DCFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install
	# log directory
	keepdir /var/log/onedrive
	fperms 775 /var/log/onedrive
	fowners root:users /var/log/onedrive
	# init script
	dobin contrib/init.d/onedrive_service.sh
	newinitd contrib/init.d/onedrive.init onedrive
}

pkg_postinst() {
	optfeature "Single Sign-On via Intune" sys-apps/intune-portal
}

# Set DC to point to a compatible gcc[d], similar to python-any-r1
_setup_gdc() {
	local gcc_pkg gcc_bin_root
	if tc-is-cross-compiler; then
		gcc_pkg="cross-${CHOST}/gcc"
		gcc_bin_root="${BROOT}/usr/${CBUILD}/${CHOST}/gcc-bin"
	else
		gcc_pkg="sys-devel/gcc"
		gcc_bin_root="${BROOT}/usr/${CHOST}/gcc-bin"
	fi

	for ((i="${MAX_GCC_SLOT}"; i>="${MIN_GCC_SLOT}"; --i)); do
		local gcc_dep="${gcc_pkg}:${i}[d]"
		einfo "Checking whether GCC ${i} is suitable ..."
		ebegin "  ${gcc_dep}"
		has_version -b "${gcc_dep}"
		eend ${?} || continue

		# Is it better to to DC="${CHOST}-gdc-${i}"?
		export DC="${gcc_bin_root}/${i}/${CHOST}-gdc"
		return
	done

	eerror "No gcc[d] implementation found for the build"
	if tc-is-cross-compiler; then
		eerror "For cross-compilation make sure ${gcc_pkg}[d] is installed"
	fi
	die "No supported GDC implementation installed."
}
