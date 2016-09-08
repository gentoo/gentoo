# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools multilib flag-o-matic user

DESCRIPTION="PKCS#11 provider cryptographic hardware"
HOMEPAGE="https://sourceforge.net/projects/opencryptoki"
SRC_URI="mirror://sourceforge/opencryptoki/${PV}/${PN}-v${PV}.tgz"

# Upstream is looking into relicensing it into CPL-1.0 entirely; the CCA
# token sources are under CPL-1.0 already.
LICENSE="CPL-0.5"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug libressl +tpm"

RDEPEND="tpm? ( app-crypt/trousers )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

# tests right now basically don't exist; the only available thing would
# test against an installed copy and would kill a running pcscd, all
# things that we're not interested to.
RESTRICT=test

pkg_setup() {
	enewgroup pkcs11
}

src_prepare() {
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	# package uses ${localstatedir}/lib as the default path, so if we
	# leave it to econf, it'll create /var/lib/lib.

	# Since upstream by default seem to enable any possible token, even
	# when they don't seem to be used, we limit ourselves to the
	# software emulation token (swtok) and if the user enabled the tpm
	# USE flag, tpmtok.  The rest of the tokens seem to be hardware- or
	# software-dependent even when they build fine without their
	# requirements, but until somebody asks for those, I'd rather not
	# enable them.

	# We don't use --enable-debug because that tinkers with the CFLAGS
	# and we don't want that. Instead we append -DDEBUG which enables
	# debug information.
	use debug && append-flags -DDEBUG

	econf \
		--localstatedir=/var \
		--enable-fast-install \
		--disable-dependency-tracking \
		--disable-debug \
		--enable-daemon \
		--enable-library \
		--disable-icatok \
		--enable-swtok \
		$(use_enable tpm tpmtok) \
		--disable-ccatok
}

src_install() {
	emake install DESTDIR="${ED}"

	# Install libopencryptoki in the standard directory for libraries.
	mv "${D}"/usr/$(get_libdir)/opencryptoki/libopencryptoki.so* "${D}"/usr/$(get_libdir) || die
	rm "${D}"/usr/$(get_libdir)/pkcs11/libopencryptoki.so
	dosym ../libopencryptoki.so /usr/$(get_libdir)/pkcs11/libopencryptoki.so

	# Remove compatibility symlinks as we _never_ required those and
	# they seem unused even upstream.
	find "${D}" -name 'PKCS11_*' -delete

	# doesn't use libltdl; only dlopen()-based interfaces
	find "${D}" -name '*.la' -delete

	# We replace their ld.so and init files (mostly designed for RedHat
	# as far as I can tell) with our own replacements.
	rm -rf "${D}"/etc/ld.so.conf.d "${D}"/etc/rc.d

	# make sure that we don't modify the init script if the USE flags
	# are enabled for the needed services.
	cp "${FILESDIR}"/pkcsslotd.init.2 "${T}"/pkcsslotd.init
	use tpm || sed -i -e '/use tcsd/d' "${T}"/pkcsslotd.init
	newinitd "${T}/pkcsslotd.init" pkcsslotd

	# We create /var dirs at runtime as needed, so don't bother installing
	# our own.
	rm -r "${D}"/var/{lib,lock} || die

	dodoc README AUTHORS FAQ TODO doc/openCryptoki-HOWTO.pdf
}
