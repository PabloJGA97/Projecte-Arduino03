#include <pgmspace.h>
#define SECRET
#define THINGNAME "Projecte_ESP32"
const char WIFI_SSID[] = "your_ssid";
const char WIFI_PASSWORD[] = "your_password";
const char AWS_IOT_ENDPOINT[] = "a302ucw63g5l7h-ats.iot.us-east-1.amazonaws.com";
// Amazon Root CA 1
static const char AWS_CERT_CA[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIDQTCCAimgA*omitted*
-----END CERTIFICATE-----
)EOF";
// Device Certificate
static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
-----BEGIN CERTIFICATE-----
MIIDWjCCAkKgAwIBAg*omitted*
-----END CERTIFICATE-----
)KEY";
// Device Private Key
static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA4VZw+FIsOCrpoiHe2KRDVgc4Cusost5ID9+o2dggXtpNVj0M
2SkBFpsQKjcfdBmoyCS+gdzGUki9KOzUkokJW2GhpgxdyuF0ZiJt83m6MuvzkQJt
Uvr+vmAmA8vsHyJphvHm4G*omitted*
-----END RSA PRIVATE KEY-----
)KEY";
