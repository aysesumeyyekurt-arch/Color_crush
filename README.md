# Color_crush
# 🎨 Color Crush

**Color Crush**, Godot Engine ve GDScript kullanılarak geliştirilmiş, 6x6 ızgara (grid) sistemine sahip modern ve tempolu bir klasik 3'lü eşleştirme (Match-3) bulmaca oyunudur. Candy Crush tarzı pürüzsüz yerçekimi mekanikleri, zamana karşı yarış modu (Time Attack) ve kalıcı yüksek skor sistemiyle oyunculara keyifli bir deneyim sunar.

---

## 🚀 Öne Çıkan Özellikler

* **Kusursuz Eşleştirme Algoritması:** Yatay ve dikey eksenlerde gerçekleşen 3'lü, 4'lü ve daha uzun zincirleme eşleşmeleri matematiksel koordinat (`Vector2`) tabanlı kusursuz bir hassasiyetle tarar.
* **Akıllı Yerçekimi (Gravity) Mekaniği:** Patlayan taşların ardından üstteki taşların aşağı kaymasını ve boşlukların en üstten yeni taşlarla pürüzsüzce dolmasını sağlar.
* **Güvenli Taş Üretimi (Safe Tile Generation):** Oyun tahtası ilk oluşturulurken veya yukarıdan yeni taşlar dökülürken, taşların kendi kendine rastgele eşleşip sonsuz bir patlama döngüsüne girmesini engelleyen akıllı komşu kontrolü içerir.
* **Zamana Karşı Yarış (Time Attack):** Oyuncunun 60 saniye süre içerisinde en yüksek skoru elde edebilmesi için tasarlanmış dinamik geri sayım sayacı.
* **Kalıcı Rekor Sistemi (High Score Save):** Godot'nun yerleşik `FileAccess` modülü kullanılarak en yüksek skorun diske (`user://highscore.save`) güvenle kaydedilmesi ve oyun yeniden başlatılsa bile rekorun saklanması.
* **Güvenli Hamle İptali (Revert Mechanism):** Eşleşme yaratmayan geçersiz hamlelerin oyun tarafından anında algılanarak taşları eski konumuna geri döndürmesi.

---

## 📸 Ekran Görüntüleri (Screenshots)

Oyun içi oynanıştan, arayüzden ve skor tablosundan kareler:
<img width="1155" height="731" alt="image" src="https://github.com/user-attachments/assets/fa8c4fb6-ef82-4dda-96a1-2204d5b89346" />
Oyun 60 saniyede en iyi skoru yapmayı amaçlar.
<img width="1153" height="746" alt="image" src="https://github.com/user-attachments/assets/5f39f957-da41-4e64-b51a-af7600583be8" />


---

## 🛠️ Kullanılan Teknolojiler ve Mimari

* **Oyun Motoru:** Godot Engine 4.x
* **Programlama Dili:** GDScript
* **Arayüz (UI/UX):** Godot Control Nodes (`Label`, `ColorRect`, `Timer`)
* **Veri Yönetimi:** Sözlük (`Dictionary`) tabanlı koordinat filtreleme ve dosya tabanlı kalıcı veri saklama.

---

## 🎮 Nasıl Oynanır?

1. Farenizin sol tuşunu kullanarak herhangi bir taşa tıklayın ve bitişiğindeki (sağ, sol, alt veya üst) bir taşla yerini değiştirin.
2. Aynı renkten en az **3 taşı** yatay veya dikey olarak yan yana getirerek patlatın.
3. Taşlar patladıkça yukarıdan yenileri dökülecek; bu sayede **zincirleme (cascade) reaksiyonlar** yaratarak puanınızı katlayabilirsiniz.
4. **60 saniyelik süreniz dolmadan** en yüksek skoru elde etmeye ve kişisel rekorunuzu kırmaya çalışın!

---
