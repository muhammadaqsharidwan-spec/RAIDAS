-- 1. Buat Tabel OPERATOR
CREATE TABLE OPERATOR (
    id_operator SERIAL PRIMARY KEY,
    nama_operator VARCHAR(150) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- 2. Buat Tabel PERANGKAT_IOT
CREATE TABLE PERANGKAT_IOT (
    id_perangkat SERIAL PRIMARY KEY,
    nama_perangkat VARCHAR(100) NOT NULL,
    jenis_perangkat VARCHAR(50),
    lokasi TEXT,
    status_perangkat VARCHAR(50)
);

-- 3. Buat Tabel PERMINTAAN_GAMBAR
CREATE TABLE PERMINTAAN_GAMBAR (
    id_permintaan SERIAL PRIMARY KEY,
    waktu_permintaan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_permintaan VARCHAR(50),
    id_operator INT,
    id_perangkat INT,
    CONSTRAINT fk_operator FOREIGN KEY (id_operator) REFERENCES OPERATOR(id_operator) ON DELETE SET NULL,
    CONSTRAINT fk_perangkat FOREIGN KEY (id_perangkat) REFERENCES PERANGKAT_IOT(id_perangkat) ON DELETE CASCADE
);

-- 4. Buat Tabel PEMANTAUAN
CREATE TABLE PEMANTAUAN (
    id_pemantauan SERIAL PRIMARY KEY,
    waktu_pemantauan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    jenis_pemantauan VARCHAR(50),
    id_perangkat INT,
    id_permintaan INT,
    CONSTRAINT fk_perangkat_pemantauan FOREIGN KEY (id_perangkat) REFERENCES PERANGKAT_IOT(id_perangkat) ON DELETE CASCADE,
    CONSTRAINT fk_permintaan_pemantauan FOREIGN KEY (id_permintaan) REFERENCES PERMINTAAN_GAMBAR(id_permintaan) ON DELETE SET NULL
);

-- 5. Buat Tabel DATA_SENSOR
CREATE TABLE DATA_SENSOR (
    id_data SERIAL PRIMARY KEY,
    ketinggian_air FLOAT,
    tingkat_kekeruhan FLOAT,
    pencahayaan FLOAT,
    id_pemantauan INT,
    CONSTRAINT fk_pemantauan_sensor FOREIGN KEY (id_pemantauan) REFERENCES PEMANTAUAN(id_pemantauan) ON DELETE CASCADE
);

-- 6. Buat Tabel GAMBAR
CREATE TABLE GAMBAR (
    id_gambar SERIAL PRIMARY KEY,
    waktu_pengambilan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    path_gambar TEXT NOT NULL,
    sumber_pengambilan VARCHAR(100),
    id_pemantauan INT,
    CONSTRAINT fk_pemantauan_gambar FOREIGN KEY (id_pemantauan) REFERENCES PEMANTAUAN(id_pemantauan) ON DELETE CASCADE
);

-- 7. Buat Tabel PENUMPUKAN_SAMPAH
-- Menggunakan id_gambar dengan constraint UNIQUE karena relasinya 1:1 di diagram
CREATE TABLE PENUMPUKAN_SAMPAH (
    id_penumpukan SERIAL PRIMARY KEY,
    jumlah_objek INT,
    tingkat_penumpukan VARCHAR(50),
    hasil_deteksi TEXT,
    confidence FLOAT,
    id_gambar INT UNIQUE,
    CONSTRAINT fk_gambar_sampah FOREIGN KEY (id_gambar) REFERENCES GAMBAR(id_gambar) ON DELETE CASCADE
);

-- 8. Buat Tabel STATUS_KONDISI
CREATE TABLE STATUS_KONDISI (
    id_status SERIAL PRIMARY KEY,
    waktu_status TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_kondisi VARCHAR(50),
    keterangan TEXT,
    id_pemantauan INT,
    id_penumpukan INT,
    CONSTRAINT fk_pemantauan_status FOREIGN KEY (id_pemantauan) REFERENCES PEMANTAUAN(id_pemantauan) ON DELETE CASCADE,
    CONSTRAINT fk_penumpukan_status FOREIGN KEY (id_penumpukan) REFERENCES PENUMPUKAN_SAMPAH(id_penumpukan) ON DELETE SET NULL
);
