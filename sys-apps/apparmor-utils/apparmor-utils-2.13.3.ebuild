# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit eapi7-ver perl-module python-r1 toolchain-funcs

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Additional userspace utils to assist with AppArmor profile management"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="https://launchpad.net/apparmor/${MY_PV}/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

COMMON_DEPEND="
	dev-lang/perl
	~sys-libs/libapparmor-${PV}
	${PYTHON_DEPS}"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	~sys-libs/libapparmor-${PV}[perl,python]
	~sys-apps/apparmor-${PV}
	dev-perl/Locale-gettext
	dev-perl/RPC-XML
	dev-perl/TermReadKey
	virtual/perl-Data-Dumper
	virtual/perl-Getopt-Long"

S=${WORKDIR}/apparmor-${PV}

src_prepare() {
	default

	sed -i binutils/Makefile \
		-e 's/Bstatic/Bdynamic/g' || die

	sed -i utils/aa-remove-unknown \
		-e 's#^\(APPARMOR_FUNCTIONS=\).*#\1/usr/libexec/rc.apparmor.functions#' || die
}

src_compile() {
	python_setup

	pushd utils > /dev/null || die
	# launches non-make subprocesses causing "make jobserver unavailable"
	# error messages to appear in generated code
	emake -j1
	popd > /dev/null || die

	pushd binutils > /dev/null || die
	export EXTRA_CFLAGS="${CFLAGS}"
	emake CC="$(tc-getCC)" USE_SYSTEM=1
	popd > /dev/null || die
}

src_install() {
	pushd utils > /dev/null || die
	perl_set_version
	emake DESTDIR="${D}" PERLDIR="${D}/${VENDOR_LIB}/Immunix" \
		VIM_INSTALL_PATH="${D}/usr/share/vim/vimfiles/syntax" install

	install_python() {
		"${PYTHON}" "${S}"/utils/python-tools-setup.py install --prefix=/usr \
			--root="${D}" --version="${PV}"
	}

	python_foreach_impl install_python
	python_replicate_script "${D}"/usr/bin/aa-easyprof "${D}"/usr/sbin/apparmor_status \
		"${D}"/usr/sbin/aa-{audit,autodep,cleanprof,complain,disable,enforce,genprof,logprof,mergeprof,status,unconfined}
	popd > /dev/null || die

	pushd binutils > /dev/null || die
	emake install DESTDIR="${D}" USE_SYSTEM=1
	popd > /dev/null || die
}
