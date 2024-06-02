# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please do not apply any patches which affect the generated output from
# `automake`, as this package is used to submit patches upstream.

PYTHON_COMPAT=( python3_{10..12} )

inherit python-any-r1

MY_PN=${PN/-vanilla}
MY_P=${MY_PN}-${PV}

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/r/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://gnu/${MY_PN}/${MY_P}.tar.xz"

	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.6
	>=dev-build/automake-wrapper-11
	>=dev-build/autoconf-2.69:*
	sys-devel/gnuconfig
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/gzip
	sys-apps/help2man
	test? (
		${PYTHON_DEPS}
		dev-util/dejagnu
		sys-devel/bison
		sys-devel/flex
	)
"

pkg_setup() {
	# Avoid python-any-r1_pkg_setup
	:
}

src_prepare() {
	default

	export WANT_AUTOCONF=2.5
	# Don't try wrapping the autotools - this thing runs as it tends
	# to be a bit esoteric, and the script does `set -e` itself.
	./bootstrap || die
	sed -i -e "/APIVERSION=/s:=.*:=${SLOT}:" configure || die

	# bug #628912
	if ! has_version -b sys-apps/texinfo ; then
		touch doc/{stamp-vti,version.texi,automake.info} || die
	fi
}

src_configure() {
	use test && python_setup
	# Also used in install.
	MY_INFODIR="${EPREFIX}/usr/share/${P}/info"
	econf \
		--datadir="${EPREFIX}"/usr/share/automake-vanilla-${PV} \
		--program-suffix="-vanilla" \
		--infodir="${MY_INFODIR}"
}

src_test() {
	# Fails with byacc/flex
	emake YACC="bison -y" LEX="flex" check
}

src_install() {
	default

	#rm "${ED}"/usr/share/aclocal/README || die
	#rmdir "${ED}"/usr/share/aclocal || die
	rm \
		"${ED}"/usr/bin/{aclocal,automake}-vanilla \
		"${ED}"/usr/share/man/man1/{aclocal,automake}-vanilla.1 || die

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} \
			/usr/share/${PN}-${SLOT}/config.${x}
	done

	# Avoid QA message about pre-compressed file in docs
	local tarfile="${ED}/usr/share/doc/automake-vanilla-${PVR}/amhello-1.0.tar.gz"
	if [[ -f "${tarfile}" ]] ; then
		gunzip "${tarfile}" || die
	fi

	pushd "${D}/${MY_INFODIR}" >/dev/null || die
	for f in *.info*; do
		# Install convenience aliases for versioned Automake pages.
		ln -s "$f" "${f/./-vanilla-${PV}.}" || die
	done
	popd >/dev/null || die

	if [[ ${PV} == 9999 ]]; then
		local major="89"
		local minor="999"
	else
		local major="$(ver_cut 1)"
		local minor="$(ver_cut 2)"
	fi
	local idx="$((99999-(major*1000+minor)))"
	newenvd - "07automake${idx}" <<-EOF
	INFOPATH="${MY_INFODIR}"
	EOF

	docompress "${MY_INFODIR}"
}
