# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools

inherit readme.gentoo-r1 autotools distutils-r1 guile-single perl-functions udev

# Check for latest firmware version on bump
FW_PV="2008-08-10"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/linux-gpib/git"
	S="${WORKDIR}/${P}/${PN}-user"
else
	SRC_URI="https://downloads.sourceforge.net/linux-gpib/${P}.tar.gz"
	S="${WORKDIR}/${PN}-user-${PV}"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Driver library for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI+="
	firmware? ( https://linux-gpib.sourceforge.io/firmware/gpib_firmware-${FW_PV}.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
IUSE="pcmcia static guile perl php python tcl doc firmware"
REQUIRED_USE="
	guile? ( ${GUILE_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

COMMONDEPEND="
	sys-libs/readline:=
	tcl? ( dev-lang/tcl:0= )
	guile? ( ${GUILE_DEPS} )
	perl? ( dev-lang/perl:= )
	php? ( dev-lang/php:= )
	firmware? ( sys-apps/fxload )
"
RDEPEND="${COMMONDEPEND}
	acct-group/gpib
	~sci-libs/linux-gpib-modules-${PV}
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${COMMONDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils[jadetex] )
	python? ( ${DISTUTILS_DEPS} ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.0-perl.patch
)

pkg_setup() {
	use guile && guile-single_pkg_setup
	use perl && perl_set_version
	use python && python_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default
		unpack "${WORKDIR}/${P}/${PN}-user-${PV}.tar.gz"
	fi
}

src_prepare() {
	default

	use guile && guile_bump_sources

	# We have to use --root instead of --prefix for setup.py.
	# Otherwise the python files are not installed properly into site-packages.
	sed -i -e \
		's/--prefix=$(DESTDIR)$(prefix)/--root=$(DESTDIR)/g' \
		language/python/Makefile.am || die

	eautoreconf

	if use python; then
		pushd language/python >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	fi
}

src_configure() {
	myeconfargs=(
		$(use_enable static)
		$(use_enable guile guile-binding)
		$(use_enable perl perl-binding)
		$(use_enable php php-binding)
		$(use_enable python python-binding)
		$(use_enable tcl tcl-binding)
		$(use_enable doc documentation)
		--disable-python-binding
	)

	econf "${myeconfargs[@]}"

	if use python; then
		pushd language/python >/dev/null || die
		distutils-r1_src_configure
		popd >/dev/null || die
	fi
}

src_compile() {
	default
	if use python; then
		pushd language/python >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	# PYTHONDONTWRITEBYTECODE=0 is required, otherwise
	# installation of the python files is skipped
	FIRM_DIR="${EPREFIX}"/usr/share/usb
	emake \
		DESTDIR="${ED}" \
		INSTALL_MOD_PATH="${ED}" \
		HOTPLUG_USB_CONF_DIR=/etc/hotplug/usb \
		UDEV_RULES_DIR="$(get_udevdir)"/rules.d \
		USB_FIRMWARE_DIR=${FIRM_DIR} \
		PYTHONDONTWRITEBYTECODE=0 \
		docdir="/usr/share/doc/${PF}/html" install

	use guile && guile_unstrip_ccache

	if use perl; then
		einfo "Installing perl module"
		cd "${S}"/language/perl || die
		emake DESTDIR="${ED}" install
		perl_fix_packlist
		perl_delete_emptybsdir
		cd "${S}" || die
	fi

	if use python; then
		pushd language/python >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi

	echo "KERNEL==\"gpib[0-9]*\",	MODE=\"0660\", GROUP=\"gpib\"" >> 99-gpib.rules || die
	udev_dorules 99-gpib.rules

	dodoc AUTHORS README* NEWS
	if [[ ${PV} == 9999 ]]; then
		dodoc ../ChangeLog
	else
		dodoc doc/linux-gpib.pdf ChangeLog
	fi

	insinto /etc
	newins util/templates/gpib.conf gpib.conf
	newins util/templates/gpib.conf gpib.conf.example

	if use pcmcia; then
		insinto /etc/pcmcia
		doins "${S}"/etc/pcmcia/*
	fi

	# remove .la files
	find "${ED}" -name '*.la' -delete || die

	DOC_CONTENTS="
As the udev rules were changed and refactored in this release it is
necessary to remove any manually installed pre-4.3.0 gpib udev rules files
in /etc/udev/rules.d/. The files to remove are:
\n
	99-agilent_82357a.rules\n
	99-gpib-generic.rules\n
	99-ni_usb_gpib.rules\n
\n
You need to run the 'gpib_config' utility to setup the driver before
you can use it. In order to do it automatically you can add to your
start script something like this (supposing the appropriate driver
is loaded on the startup):
\n
		gpib_config --minor 0
\n
To give a user access to the computer's gpib board you will have to add
them to the group 'gpib' or, you could change the permissions on the device
files /dev/gpib[0-15] to something you like better, using 'chmod'
\n
Edit /etc/gpib.conf to match your interface board, and any devices you wish
to open via ibfind().  See the documentation in /usr/share/linux-gpib/html for
more information.
\n
"

	if use pcmcia; then
		DOC_CONTENTS+='
For PCMCIA cards:\n
All files needed for a PCMCIA board were copied to /etc/pcmcia.
You may wish to edit the options passed to the gpib_config call in the
/etc/pcmcia/linux-gpib-pcmcia script.
You may need to send a SIGHUP signal to the cardmgr daemon to force it
to reload the files in /etc/pcmcia \(alternatively you could use your
pcmcia init.d script to restart the cardmgr, or you could just reboot\).
The driver module will be loaded as needed by the cardmgr.

'
	fi

	if use firmware; then
		DOC_CONTENTS+='
For Agilent \(HP\) 82341C and 82341D cards:
The firmware for these boards is uploaded by passing the appropriate
firmware file from /usr/share/linux-gpib/hp_82341 directory to
gpib_config using the -I or --init-data command line option. Example:\n
gpib_config --minor 0 --init-data /usr/share/linux-gpib/hp_82341/hp_82341c_fw.bin
'
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	udev_reload
}

pkg_postrm() {
	udev_reload
}
